<?php
/**
 * Ceremony Controller
 * Batak traditional event management
 */

namespace App\Controllers;

use App\Models\Ceremony;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;

class CeremonyController
{
    public function index(Request $request, Response $response): Response
    {
        $params = $request->getQueryParams();
        $query = Ceremony::with(['marriage', 'rajaParhata']);

        if (!empty($params['type'])) $query->where('ceremony_type', $params['type']);
        if (!empty($params['status'])) $query->where('status', $params['status']);

        $items = $query->orderBy('ceremony_date', 'desc')->get();

        return $this->jsonResponse($response, [
            'success' => true,
            'data' => $items
        ]);
    }

    public function store(Request $request, Response $response): Response
    {
        $body = $request->getParsedBody() ?? [];
        $ceremony = Ceremony::create([
            'ceremony_type' => $body['ceremony_type'] ?? 'OTHER',
            'ceremony_name' => $body['ceremony_name'] ?? 'Acara Adat',
            'marriage_id' => $body['marriage_id'] ?? null,
            'ceremony_date' => $body['ceremony_date'] ?? null,
            'ceremony_location' => $body['ceremony_location'] ?? null,
            'raja_parhata_id' => $body['raja_parhata_id'] ?? null,
            'hula_hula_marga_id' => $body['hula_hula_marga_id'] ?? null,
            'boru_marga_id' => $body['boru_marga_id'] ?? null,
            'status' => 'PLANNED',
            'notes' => $body['notes'] ?? null,
            'created_by' => $request->getAttribute('user_id') ?? null,
        ]);

        return $this->jsonResponse($response, [
            'success' => true,
            'data' => ['ceremony_id' => $ceremony->id, 'message' => 'Acara berhasil dibuat']
        ], 201);
    }

    public function show(Request $request, Response $response, array $args): Response
    {
        $id = (int)$args['id'];
        $ceremony = Ceremony::with(['marriage', 'rajaParhata'])->find($id);
        if (!$ceremony) {
            return $this->jsonResponse($response, ['success' => false, 'error' => 'Acara tidak ditemukan'], 404);
        }
        return $this->jsonResponse($response, ['success' => true, 'data' => $ceremony]);
    }

    public function update(Request $request, Response $response, array $args): Response
    {
        $id = (int)$args['id'];
        $ceremony = Ceremony::find($id);
        if (!$ceremony) {
            return $this->jsonResponse($response, ['success' => false, 'error' => 'Acara tidak ditemukan'], 404);
        }

        $body = $request->getParsedBody() ?? [];
        if (isset($body['status'])) $ceremony->status = $body['status'];
        if (isset($body['ceremony_date'])) $ceremony->ceremony_date = $body['ceremony_date'];
        if (isset($body['ceremony_location'])) $ceremony->ceremony_location = $body['ceremony_location'];
        if (isset($body['notes'])) $ceremony->notes = $body['notes'];
        $ceremony->save();

        return $this->jsonResponse($response, ['success' => true, 'data' => $ceremony]);
    }

    private function jsonResponse(Response $response, array $data, int $status = 200): Response
    {
        $response->getBody()->write(json_encode($data));
        return $response->withHeader('Content-Type', 'application/json')->withStatus($status);
    }
}
