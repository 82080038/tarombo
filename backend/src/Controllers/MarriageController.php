<?php
/**
 * Marriage Controller
 * Handles marriage CRUD and ceremony stage management
 */

namespace App\Controllers;

use App\Models\Marriage;
use App\Models\MarriageStage;
use App\Models\Person;
use App\Models\ForbiddenMargaPair;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;

class MarriageController
{
    /**
     * GET /marriages
     */
    public function index(Request $request, Response $response): Response
    {
        $queryParams = $request->getQueryParams();
        $page = max(1, (int)($queryParams['page'] ?? 1));
        $limit = min(100, max(1, (int)($queryParams['limit'] ?? 20)));
        
        $query = Marriage::with(['husband', 'wife', 'husband.marga', 'wife.marga']);
        
        if (!empty($queryParams['person_id'])) {
            $personId = (int)$queryParams['person_id'];
            $query->where(function ($q) use ($personId) {
                $q->where('husband_id', $personId)->orWhere('wife_id', $personId);
            });
        }
        
        if (!empty($queryParams['status'])) {
            $query->where('status', $queryParams['status']);
        }
        
        $total = $query->count();
        $items = $query->offset(($page - 1) * $limit)->limit($limit)
            ->orderBy('tanggal_perkawinan', 'desc')
            ->get();
        
        $data = $items->map(function ($m) {
            return [
                'id' => $m->id,
                'husband' => [
                    'id' => $m->husband->id,
                    'nama' => $m->husband->nama,
                    'marga' => $m->husband->marga->nama ?? null
                ],
                'wife' => [
                    'id' => $m->wife->id,
                    'nama' => $m->wife->nama,
                    'marga' => $m->wife->marga->nama ?? null
                ],
                'tanggal_perkawinan' => $m->tanggal_perkawinan,
                'tempat_perkawinan' => $m->tempat_perkawinan,
                'status' => $m->status,
                'created_at' => $m->created_at,
            ];
        });
        
        return $this->jsonResponse($response, [
            'success' => true,
            'data' => [
                'items' => $data,
                'pagination' => [
                    'page' => $page,
                    'limit' => $limit,
                    'total' => $total,
                    'total_pages' => (int)ceil($total / $limit)
                ]
            ]
        ]);
    }
    
    /**
     * GET /marriages/{id}
     */
    public function show(Request $request, Response $response, array $args): Response
    {
        $id = (int)$args['id'];
        $marriage = Marriage::with(['husband', 'wife', 'husband.marga', 'wife.marga'])
            ->find($id);
        
        if (!$marriage) {
            return $this->jsonResponse($response, [
                'success' => false,
                'error' => ['code' => 'NOT_FOUND', 'message' => 'Data perkawinan tidak ditemukan']
            ], 404);
        }
        
        $stages = MarriageStage::where('marriage_id', $id)
            ->orderBy('stage_order')
            ->get();

        // Auto-create default stages if missing (for pre-migration marriages)
        if ($stages->isEmpty()) {
            foreach (MarriageStage::defaultStages() as $stage) {
                MarriageStage::create([
                    'marriage_id' => $id,
                    'stage_name' => $stage['stage_name'],
                    'stage_order' => $stage['stage_order'],
                    'status' => 'pending',
                ]);
            }
            $stages = MarriageStage::where('marriage_id', $id)->orderBy('stage_order')->get();
        }
        
        return $this->jsonResponse($response, [
            'success' => true,
            'data' => [
                'id' => $marriage->id,
                'husband' => [
                    'id' => $marriage->husband->id,
                    'nama' => $marriage->husband->nama,
                    'marga' => $marriage->husband->marga->nama ?? null
                ],
                'wife' => [
                    'id' => $marriage->wife->id,
                    'nama' => $marriage->wife->nama,
                    'marga' => $marriage->wife->marga->nama ?? null
                ],
                'tanggal_perkawinan' => $marriage->tanggal_perkawinan,
                'tempat_perkawinan' => $marriage->tempat_perkawinan,
                'status' => $marriage->status,
                'stages' => $stages,
                'completed_stages' => $stages->where('status', 'completed')->count(),
                'total_stages' => $stages->count(),
                'created_at' => $marriage->created_at,
            ]
        ]);
    }
    
    /**
     * POST /marriages
     */
    public function store(Request $request, Response $response): Response
    {
        $body = $request->getParsedBody() ?? [];
        
        $husbandId = (int)($body['husband_id'] ?? 0);
        $wifeId = (int)($body['wife_id'] ?? 0);
        
        // Validation
        if (!$husbandId || !$wifeId) {
            return $this->jsonResponse($response, [
                'success' => false,
                'error' => ['code' => 'INVALID_INPUT', 'message' => 'ID pengantin pria dan wanita wajib diisi']
            ], 400);
        }
        
        $husband = Person::find($husbandId);
        $wife = Person::find($wifeId);
        
        if (!$husband || !$wife) {
            return $this->jsonResponse($response, [
                'success' => false,
                'error' => ['code' => 'PERSON_NOT_FOUND', 'message' => 'Salah satu pengantin tidak ditemukan']
            ], 404);
        }
        
        // BR-PRK-006: Same marga check
        if ($husband->marga_id === $wife->marga_id) {
            return $this->jsonResponse($response, [
                'success' => false,
                'error' => [
                    'code' => 'SAME_MARGA_MARRIAGE',
                    'message' => 'Perkawinan sesama marga tidak diperbolehkan menurut adat Batak',
                    'details' => ['husband_marga' => $husband->marga->nama, 'wife_marga' => $wife->marga->nama]
                ]
            ], 400);
        }
        
        // BR-PRK-007: Forbidden pair check
        $forbidden = ForbiddenMargaPair::where(function ($q) use ($husband, $wife) {
            $q->where(function ($q2) use ($husband, $wife) {
                $q2->where('marga_a_id', $husband->marga_id)->where('marga_b_id', $wife->marga_id);
            })->orWhere(function ($q2) use ($husband, $wife) {
                $q2->where('marga_a_id', $wife->marga_id)->where('marga_b_id', $husband->marga_id);
            });
        })->first();
        
        if ($forbidden) {
            return $this->jsonResponse($response, [
                'success' => false,
                'error' => [
                    'code' => 'FORBIDDEN_MARGA_PAIR',
                    'message' => $forbidden->reason,
                    'details' => ['rule' => $forbidden->rule_reference]
                ]
            ], 400);
        }
        
        $marriage = Marriage::create([
            'husband_id' => $husbandId,
            'wife_id' => $wifeId,
            'tanggal_perkawinan' => $body['tanggal_perkawinan'] ?? null,
            'tempat_perkawinan' => $body['tempat_perkawinan'] ?? null,
            'status' => 'active',
            'hula_hula_marga_id' => $wife->marga_id,
            'boru_marga_id' => $husband->marga_id,
        ]);
        
        // Create default stages
        foreach (MarriageStage::defaultStages() as $stage) {
            MarriageStage::create([
                'marriage_id' => $marriage->id,
                'stage_name' => $stage['stage_name'],
                'stage_order' => $stage['stage_order'],
                'status' => 'pending',
            ]);
        }
        
        return $this->jsonResponse($response, [
            'success' => true,
            'data' => ['marriage_id' => $marriage->id, 'message' => 'Perkawinan berhasil dicatat']
        ], 201);
    }
    
    /**
     * PUT /marriages/{id}/stages/{stage_id}
     */
    public function updateStage(Request $request, Response $response, array $args): Response
    {
        $marriageId = (int)$args['id'];
        $stageId = (int)$args['stage_id'];
        $body = $request->getParsedBody() ?? [];
        
        $stage = MarriageStage::where('id', $stageId)
            ->where('marriage_id', $marriageId)
            ->first();
        
        if (!$stage) {
            return $this->jsonResponse($response, [
                'success' => false,
                'error' => ['code' => 'STAGE_NOT_FOUND', 'message' => 'Tahapan tidak ditemukan']
            ], 404);
        }
        
        if (isset($body['status'])) {
            $stage->status = $body['status'];
        }
        if (isset($body['stage_date'])) {
            $stage->stage_date = $body['stage_date'];
        }
        if (isset($body['stage_location'])) {
            $stage->stage_location = $body['stage_location'];
        }
        if (isset($body['details'])) {
            $stage->details = $body['details'];
        }
        
        $stage->save();
        
        return $this->jsonResponse($response, [
            'success' => true,
            'data' => $stage
        ]);
    }
    
    /**
     * DELETE /marriages/{id}
     */
    public function destroy(Request $request, Response $response, array $args): Response
    {
        $id = (int)$args['id'];
        $marriage = Marriage::find($id);
        
        if (!$marriage) {
            return $this->jsonResponse($response, [
                'success' => false,
                'error' => ['code' => 'NOT_FOUND', 'message' => 'Data perkawinan tidak ditemukan']
            ], 404);
        }
        
        $marriage->delete();
        
        return $this->jsonResponse($response, [
            'success' => true,
            'message' => 'Data perkawinan berhasil dihapus'
        ]);
    }
    
    /**
     * GET /margas/{id}/can-marry/{target_id}
     */
    public function canMarry(Request $request, Response $response, array $args): Response
    {
        $margaId = (int)$args['id'];
        $targetId = (int)$args['target_id'];
        
        if ($margaId === $targetId) {
            return $this->jsonResponse($response, [
                'success' => true,
                'data' => [
                    'can_marry' => false,
                    'reason' => 'Perkawinan sesama marga tidak diperbolehkan',
                    'prohibition_details' => ['type' => 'SAME_MARGA', 'code' => 'BR-PRK-006']
                ]
            ]);
        }
        
        $forbidden = ForbiddenMargaPair::where(function ($q) use ($margaId, $targetId) {
            $q->where(function ($q2) use ($margaId, $targetId) {
                $q2->where('marga_a_id', $margaId)->where('marga_b_id', $targetId);
            })->orWhere(function ($q2) use ($margaId, $targetId) {
                $q2->where('marga_a_id', $targetId)->where('marga_b_id', $margaId);
            });
        })->first();
        
        if ($forbidden) {
            return $this->jsonResponse($response, [
                'success' => true,
                'data' => [
                    'can_marry' => false,
                    'reason' => $forbidden->reason,
                    'prohibition_details' => ['type' => 'FORBIDDEN_PAIR', 'code' => $forbidden->rule_reference]
                ]
            ]);
        }
        
        return $this->jsonResponse($response, [
            'success' => true,
            'data' => [
                'can_marry' => true,
                'reason' => null
            ]
        ]);
    }
    
    private function jsonResponse(Response $response, array $data, int $status = 200): Response
    {
        $response->getBody()->write(json_encode($data));
        return $response->withHeader('Content-Type', 'application/json')->withStatus($status);
    }
}
