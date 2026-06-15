<?php
namespace App\Controllers;
use App\Models\Tradition;
use App\Models\Story;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
class HeritageController
{
    public function getTraditions(Request $request, Response $response): Response
    {
        $query = Tradition::with(['marga', 'creator']);
        $traditions = $query->orderBy('created_at', 'desc')->get();
        return $this->jsonResponse($response, ['success' => true, 'data' => $traditions]);
    }
    public function createTradition(Request $request, Response $response): Response
    {
        $body = $request->getParsedBody() ?? [];
        $tradition = Tradition::create([
            'nama' => $body['nama'],
            'kategori' => $body['kategori'],
            'deskripsi' => $body['deskripsi'] ?? null,
            'asal_usul' => $body['asal_usul'] ?? null,
            'prosedur' => $body['prosedur'] ?? null,
            'marga_id' => $body['marga_id'] ?? null,
            'status' => 'aktif',
            'created_by' => $request->getAttribute('user_id')
        ]);
        return $this->jsonResponse($response, ['success' => true, 'data' => $tradition], 201);
    }
    public function getStories(Request $request, Response $response): Response
    {
        $query = Story::with(['person', 'penulis', 'marga']);
        $stories = $query->orderBy('created_at', 'desc')->get();
        return $this->jsonResponse($response, ['success' => true, 'data' => $stories]);
    }
    public function createStory(Request $request, Response $response): Response
    {
        $body = $request->getParsedBody() ?? [];
        $story = Story::create([
            'judul' => $body['judul'],
            'tipe' => $body['tipe'],
            'konten' => $body['konten'],
            'person_id' => $body['person_id'] ?? null,
            'penulis_id' => $request->getAttribute('user_id'),
            'marga_id' => $body['marga_id'] ?? null,
            'tanggal_kejadian' => $body['tanggal_kejadian'] ?? null,
            'lokasi' => $body['lokasi'] ?? null,
            'status' => 'draft'
        ]);
        return $this->jsonResponse($response, ['success' => true, 'data' => $story], 201);
    }
    public function publishStory(Request $request, Response $response, array $args): Response
    {
        $id = (int)$args['id'];
        $story = Story::find($id);
        if (!$story) {
            return $this->jsonResponse($response, ['success' => false, 'error' => 'Story not found'], 404);
        }
        $story->status = 'published';
        $story->save();
        return $this->jsonResponse($response, ['success' => true, 'data' => $story]);
    }
    private function jsonResponse(Response $response, array $data, int $status = 200): Response
    {
        $response->getBody()->write(json_encode($data));
        return $response->withHeader('Content-Type', 'application/json')->withStatus($status);
    }
}
