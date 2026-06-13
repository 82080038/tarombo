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
    public function __construct(
        private PartuturanService $partuturanService,
        private AuditService $auditService
    ) {}
    
    /**
     * List all persons with pagination
     * GET /api/v1/persons
     */
    public function index(Request $request, Response $response): Response
    {
        $query = Person::with(['marga', 'father', 'mother'])
            ->active();
        
        // Filter by marga
        if ($margaId = $request->getQueryParams()['marga_id'] ?? null) {
            $query->byMarga((int) $margaId);
        }
        
        // Filter by search
        if ($search = $request->getQueryParams()['search'] ?? null) {
            $query->where('nama', 'like', "%$search%");
        }
        
        $perPage = (int) ($request->getQueryParams()['per_page'] ?? 20);
        $persons = $query->paginate($perPage);
        
        $response->getBody()->write(json_encode([
            'data' => $persons->items(),
            'meta' => [
                'current_page' => $persons->currentPage(),
                'last_page' => $persons->lastPage(),
                'per_page' => $persons->perPage(),
                'total' => $persons->total()
            ]
        ]));
        
        return $response->withHeader('Content-Type', 'application/json');
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
            'father',
            'mother',
            'childrenAsFather',
            'childrenAsMother',
            'marriagesAsHusband.wife',
            'marriagesAsWife.husband'
        ])->find($id);
        
        if (!$person) {
            $response->getBody()->write(json_encode([
                'error' => 'Person not found',
                'code' => 'PERSON_NOT_FOUND'
            ]));
            return $response
                ->withHeader('Content-Type', 'application/json')
                ->withStatus(404);
        }
        
        $response->getBody()->write(json_encode([
            'data' => $person->toArray(),
            'relationships' => [
                'tulang' => $person->getTulang(),
                'namboru' => $person->getNamboru()
            ]
        ]));
        
        return $response->withHeader('Content-Type', 'application/json');
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
            $response->getBody()->write(json_encode([
                'error' => 'Validation failed',
                'errors' => $errors,
                'code' => 'VALIDATION_ERROR'
            ]));
            return $response
                ->withHeader('Content-Type', 'application/json')
                ->withStatus(422);
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
            $response->getBody()->write(json_encode([
                'error' => 'Person already exists',
                'code' => 'BR-SYS-002',
                'existing_person' => $existing->toArray()
            ]));
            return $response
                ->withHeader('Content-Type', 'application/json')
                ->withStatus(422);
        }
        
        // Create person
        $data['status'] = 'active';
        $data['created_by'] = $request->getAttribute('user_id') ?? null;
        
        $person = Person::create($data);
        
        // Audit log (BR-HIS-001)
        $this->auditService->log('CREATE', $person, $data['created_by']);
        
        $response->getBody()->write(json_encode([
            'data' => $person->toArray(),
            'message' => 'Person created successfully'
        ]));
        
        return $response
            ->withHeader('Content-Type', 'application/json')
            ->withStatus(201);
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
        
        $response->getBody()->write(json_encode([
            'data' => $person->fresh()->toArray(),
            'message' => 'Person updated successfully'
        ]));
        
        return $response->withHeader('Content-Type', 'application/json');
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
            $response->getBody()->write(json_encode([
                'error' => 'Cannot delete person with children',
                'code' => 'HAS_CHILDREN',
                'children_count' => $person->allChildren()->count()
            ]));
            return $response
                ->withHeader('Content-Type', 'application/json')
                ->withStatus(422);
        }
        
        $oldValues = $person->toArray();
        
        // Soft delete
        $person->update(['status' => 'deleted']);
        
        // Audit log (BR-HIS-003)
        $this->auditService->log('DELETE', $person, $request->getAttribute('user_id'), $oldValues, null);
        
        $response->getBody()->write(json_encode([
            'message' => 'Person deleted successfully'
        ]));
        
        return $response->withHeader('Content-Type', 'application/json');
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
            $response->getBody()->write(json_encode([
                'error' => 'Missing parameters',
                'required' => ['from', 'to']
            ]));
            return $response
                ->withHeader('Content-Type', 'application/json')
                ->withStatus(400);
        }
        
        $from = Person::find($fromId);
        $to = Person::find($toId);
        
        if (!$from || !$to) {
            return $this->notFound($response);
        }
        
        $result = $this->partuturanService->calculate($from, $to);
        
        $response->getBody()->write(json_encode([
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
        ]));
        
        return $response->withHeader('Content-Type', 'application/json');
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
        $response->getBody()->write(json_encode([
            'error' => 'Person not found',
            'code' => 'PERSON_NOT_FOUND'
        ]));
        return $response
            ->withHeader('Content-Type', 'application/json')
            ->withStatus(404);
    }
    
    private function validationError(Response $response, array $errors): Response
    {
        $response->getBody()->write(json_encode([
            'error' => 'Validation failed',
            'errors' => $errors
        ]));
        return $response
            ->withHeader('Content-Type', 'application/json')
            ->withStatus(422);
    }
}
