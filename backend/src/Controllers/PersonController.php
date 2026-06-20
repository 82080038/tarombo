<?php
/**
 * Person Controller
 * Handles CRUD operations for persons
 */

namespace App\Controllers;

use App\Models\Person;
use App\Models\Marga;
use App\Services\PartuturanService;
use App\Services\AuditService;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;

class PersonController
{
    private PartuturanService $partuturanService;
    private AuditService $auditService;

    public function __construct()
    {
        $this->partuturanService = new PartuturanService();
        $this->auditService = new AuditService();
    }
    
    /**
     * List all persons with pagination
     * GET /api/v1/persons
     */
    public function index(Request $request, Response $response): Response
    {
        $query = Person::with(['marga', 'turunanMarga', 'asalUsulMarga', 'father', 'mother'])
            ->active();
        
        // Filter by marga
        if ($margaId = $request->getQueryParams()['marga_id'] ?? null) {
            $query->byMarga((int) $margaId);
        }
        
        // Filter by search (search in nama, nama_depan, and marga)
        if ($search = $request->getQueryParams()['search'] ?? null) {
            $escapedSearch = str_replace(['\\', '%', '_'], ['\\\\', '\\%', '\\_'], $search);
            $query->where(function($q) use ($escapedSearch) {
                $q->where('nama', 'like', "%$escapedSearch%")
                  ->orWhere('nama_depan', 'like', "%$escapedSearch%");
            });
        }
        
        $perPage = (int) ($request->getQueryParams()['per_page'] ?? 20);
        $persons = $query->paginate($perPage);
        
        return $this->jsonResponse($response, [
            'success' => true,
            'data' => array_map(function($person) {
                $data = $person->toArray();
                $data['full_name'] = $person->full_name;
                return $data;
            }, $persons->items()),
            'meta' => [
                'current_page' => $persons->currentPage(),
                'last_page' => $persons->lastPage(),
                'per_page' => $persons->perPage(),
                'total' => $persons->total()
            ]
        ]);
    }
    
    /**
     * Get person detail
     * GET /api/v1/persons/{id}
     */
    public function show(Request $request, Response $response, array $args): Response
    {
        $id = (int) $args['id'];
        
        $person = Person::with([
            'marga',
            'turunanMarga',
            'asalUsulMarga',
            'father',
            'mother',
            'childrenAsFather',
            'childrenAsMother',
            'marriagesAsHusband.wife',
            'marriagesAsWife.husband'
        ])->find($id);
        
        if (!$person) {
            return $this->jsonResponse($response, [
                'success' => false,
                'error' => ['code' => 'PERSON_NOT_FOUND', 'message' => 'Person not found']
            ], 404);
        }
        
        return $this->jsonResponse($response, [
            'success' => true,
            'data' => array_merge($person->toArray(), ['full_name' => $person->full_name]),
            'relationships' => [
                'tulang' => $person->getTulang(),
                'namboru' => $person->getNamboru(),
                'bere' => $person->getBere(),
                'pariban_candidates' => $person->getParibanCandidates()
            ]
        ]);
    }
    
    /**
     * Create person
     * POST /api/v1/persons
     * Business Rules: BR-SYS-001, BR-MRG-001
     */
    public function store(Request $request, Response $response): Response
    {
        $data = $request->getParsedBody();
        
        // Validation
        $errors = $this->validatePersonData($data);
        if (!empty($errors)) {
            return $this->jsonResponse($response, [
                'success' => false,
                'error' => ['code' => 'VALIDATION_ERROR', 'message' => 'Validation failed', 'details' => $errors]
            ], 422);
        }
        
        // BR-MRG-001: Patrilineal inheritance
        if (!empty($data['father_id'])) {
            $father = Person::find($data['father_id']);
            if ($father) {
                $data['marga_id'] = $father->marga_id;
            }
        }
        
        // Check uniqueness (BR-SYS-002)
        $existing = Person::where('nama', $data['nama'])
            ->where('marga_id', $data['marga_id'])
            ->where('tanggal_lahir', $data['tanggal_lahir'] ?? null)
            ->first();
        
        if ($existing) {
            return $this->jsonResponse($response, [
                'success' => false,
                'error' => ['code' => 'BR-SYS-002', 'message' => 'Person already exists', 'existing_person' => $existing->toArray()]
            ], 422);
        }
        
        // Create person
        $data['status'] = 'active';
        $data['created_by'] = $request->getAttribute('user_id') ?? null;
        
        $person = Person::create($data);
        
        // Audit log (BR-HIS-001)
        $this->auditService->log('CREATE', $person, $data['created_by']);
        
        return $this->jsonResponse($response, [
            'success' => true,
            'data' => $person->toArray(),
            'message' => 'Person created successfully'
        ], 201);
    }
    
    /**
     * Update person
     * PUT /api/v1/persons/{id}
     */
    public function update(Request $request, Response $response, array $args): Response
    {
        $id = (int) $args['id'];
        $person = Person::find($id);
        
        if (!$person) {
            return $this->notFound($response);
        }
        
        $data = $request->getParsedBody();
        $oldValues = $person->toArray();
        
        // Validate
        $errors = $this->validatePersonData($data, $id);
        if (!empty($errors)) {
            return $this->validationError($response, $errors);
        }
        
        // Update
        $person->update($data);
        
        // Audit log (BR-HIS-002)
        $this->auditService->log('UPDATE', $person, $request->getAttribute('user_id'), $oldValues, $person->toArray());
        
        return $this->jsonResponse($response, [
            'success' => true,
            'data' => $person->fresh()->toArray(),
            'message' => 'Person updated successfully'
        ]);
    }
    
    /**
     * Delete person (soft delete)
     * DELETE /api/v1/persons/{id}
     */
    public function destroy(Request $request, Response $response, array $args): Response
    {
        $id = (int) $args['id'];
        $person = Person::find($id);
        
        if (!$person) {
            return $this->notFound($response);
        }
        
        // Check if person has children (should warn)
        if ($person->allChildren()->count() > 0) {
            return $this->jsonResponse($response, [
                'success' => false,
                'error' => ['code' => 'HAS_CHILDREN', 'message' => 'Cannot delete person with children', 'children_count' => $person->allChildren()->count()]
            ], 422);
        }
        
        $oldValues = $person->toArray();
        
        // Soft delete
        $person->update(['status' => 'deleted']);
        
        // Audit log (BR-HIS-003)
        $this->auditService->log('DELETE', $person, $request->getAttribute('user_id'), $oldValues, null);
        
        return $this->jsonResponse($response, [
            'success' => true,
            'message' => 'Person deleted successfully'
        ]);
    }
    
    /**
     * Calculate partuturan between two persons
     * GET /api/v1/partuturan/calculate?from={id}&to={id}
     */
    public function calculatePartuturan(Request $request, Response $response): Response
    {
        $params = $request->getQueryParams();
        $fromId = (int) ($params['from'] ?? 0);
        $toId = (int) ($params['to'] ?? 0);
        
        if (!$fromId || !$toId) {
            return $this->jsonResponse($response, [
                'success' => false,
                'error' => ['code' => 'MISSING_PARAMS', 'message' => 'Missing parameters', 'required' => ['from', 'to']]
            ], 400);
        }
        
        $from = Person::find($fromId);
        $to = Person::find($toId);
        
        if (!$from || !$to) {
            return $this->notFound($response);
        }
        
        $result = $this->partuturanService->calculate($from, $to);
        
        return $this->jsonResponse($response, [
            'success' => true,
            'data' => [
                'from_person' => [
                    'id' => $from->id,
                    'nama' => $from->full_name
                ],
                'to_person' => [
                    'id' => $to->id,
                    'nama' => $to->full_name
                ],
                'relationship' => $result->term,
                'indonesian' => $result->indonesian,
                'path' => $result->path,
                'explanation' => $result->explanation
            ]
        ]);
    }
    
    /**
     * Validation helper
     */
    private function validatePersonData(array $data, ?int $excludeId = null): array
    {
        $errors = [];
        
        if (empty($data['nama'])) {
            $errors['nama'] = 'Nama is required';
        }
        
        if (empty($data['marga_id']) && empty($data['father_id'])) {
            $errors['marga_id'] = 'Either marga_id or father_id is required';
        }
        
        if (!empty($data['jenis_kelamin']) && !in_array($data['jenis_kelamin'], ['L', 'P'])) {
            $errors['jenis_kelamin'] = 'Jenis kelamin must be L or P';
        }
        
        if (!empty($data['father_id'])) {
            $father = Person::find($data['father_id']);
            if (!$father) {
                $errors['father_id'] = 'Father not found';
            } elseif ($father->jenis_kelamin !== 'L') {
                $errors['father_id'] = 'Father must be male';
            }
        }
        
        if (!empty($data['mother_id'])) {
            $mother = Person::find($data['mother_id']);
            if (!$mother) {
                $errors['mother_id'] = 'Mother not found';
            } elseif ($mother->jenis_kelamin !== 'P') {
                $errors['mother_id'] = 'Mother must be female';
            }
        }
        
        return $errors;
    }
    
    private function notFound(Response $response): Response
    {
        return $this->jsonResponse($response, [
            'success' => false,
            'error' => ['code' => 'PERSON_NOT_FOUND', 'message' => 'Person not found']
        ], 404);
    }
    
    private function validationError(Response $response, array $errors): Response
    {
        return $this->jsonResponse($response, [
            'success' => false,
            'error' => ['code' => 'VALIDATION_ERROR', 'message' => 'Validation failed', 'details' => $errors]
        ], 422);
    }
    
    private function jsonResponse(Response $response, array $data, int $status = 200): Response
    {
        $response->getBody()->write(json_encode($data));
        return $response
            ->withHeader('Content-Type', 'application/json')
            ->withStatus($status);
    }
}
