<?php
namespace App\Controllers;
use App\Models\RumahKeluarga;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
class LocationController
{
    public function index(Request $request, Response $response): Response
    {
        $query = RumahKeluarga::with(['person']);
        $rumah = $query->orderBy('created_at', 'desc')->get();
        return $this->jsonResponse($response, ['success' => true, 'data' => $rumah]);
    }
    public function show(Request $request, Response $response, array $args): Response
    {
        $id = (int)$args['id'];
        $rumah = RumahKeluarga::with(['person'])->find($id);
        if (!$rumah) {
            return $this->jsonResponse($response, ['success' => false, 'error' => ['code' => 'RUMAH_NOT_FOUND', 'message' => 'Rumah not found']], 404);
        }
        return $this->jsonResponse($response, ['success' => true, 'data' => $rumah]);
    }
    public function store(Request $request, Response $response): Response
    {
        $body = $request->getParsedBody() ?? [];
        $rumah = RumahKeluarga::create([
            'nama' => $body['nama'],
            'person_id' => $body['person_id'],
            'alamat' => $body['alamat'],
            'kota' => $body['kota'] ?? null,
            'provinsi' => $body['provinsi'] ?? null,
            'latitude' => $body['latitude'] ?? null,
            'longitude' => $body['longitude'] ?? null,
            'tipe' => $body['tipe'] ?? 'rumah_kediaman',
            'status' => $body['status'] ?? 'dihuni',
            'foto_path' => $body['foto_path'] ?? null,
            'deskripsi' => $body['deskripsi'] ?? null
        ]);
        return $this->jsonResponse($response, ['success' => true, 'data' => $rumah], 201);
    }
    public function update(Request $request, Response $response, array $args): Response
    {
        $id = (int)$args['id'];
        $body = $request->getParsedBody() ?? [];
        $rumah = RumahKeluarga::find($id);
        if (!$rumah) {
            return $this->jsonResponse($response, ['success' => false, 'error' => ['code' => 'RUMAH_NOT_FOUND', 'message' => 'Rumah not found']], 404);
        }
        $rumah->update($body);
        return $this->jsonResponse($response, ['success' => true, 'data' => $rumah]);
    }
    public function destroy(Request $request, Response $response, array $args): Response
    {
        $id = (int)$args['id'];
        $rumah = RumahKeluarga::find($id);
        if (!$rumah) {
            return $this->jsonResponse($response, ['success' => false, 'error' => ['code' => 'RUMAH_NOT_FOUND', 'message' => 'Rumah not found']], 404);
        }
        $rumah->delete();
        return $this->jsonResponse($response, ['success' => true, 'message' => 'Rumah deleted']);
    }
    private function jsonResponse(Response $response, array $data, int $status = 200): Response
    {
        $response->getBody()->write(json_encode($data));
        return $response->withHeader('Content-Type', 'application/json')->withStatus($status);
    }
}
