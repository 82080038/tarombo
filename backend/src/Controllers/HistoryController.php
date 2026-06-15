<?php
namespace App\Controllers;
use App\Models\EntityHistory;
use App\Models\EntityTimeline;
use App\Models\OralTradition;
use App\Models\TraditionalKnowledge;
use App\Models\CulturalSite;
use App\Services\AuditService;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
class HistoryController
{
    private AuditService $auditService;

    public function __construct()
    {
        $this->auditService = new AuditService();
    }
    public function getEntityHistory(Request $request, Response $response, array $args): Response
    {
        $entityType = $args['type'];
        $entityId = (int)$args['id'];
        $history = EntityHistory::with('user')->where('entity_type', $entityType)->where('entity_id', $entityId)->orderBy('changed_at', 'desc')->get();
        return $this->jsonResponse($response, ['success' => true, 'data' => $history]);
    }
    public function getEntityTimeline(Request $request, Response $response, array $args): Response
    {
        $entityType = $args['type'];
        $entityId = (int)$args['id'];
        $timeline = EntityTimeline::with('creator')->where('entity_type', $entityType)->where('entity_id', $entityId)->orderBy('event_date', 'asc')->get();
        return $this->jsonResponse($response, ['success' => true, 'data' => $timeline]);
    }
    public function getOralTraditions(Request $request, Response $response): Response
    {
        $query = OralTradition::with(['marga', 'creator']);
        $traditions = $query->orderBy('created_at', 'desc')->get();
        return $this->jsonResponse($response, ['success' => true, 'data' => $traditions]);
    }
    public function createOralTradition(Request $request, Response $response): Response
    {
        $body = $request->getParsedBody() ?? [];
        $tradition = OralTradition::create([
            'kategori' => $body['kategori'],
            'judul' => $body['judul'],
            'konten' => $body['konten'],
            'bahasa_asli' => $body['bahasa_asli'] ?? null,
            'terjemahan' => $body['terjemahan'] ?? null,
            'transliterasi' => $body['transliterasi'] ?? null,
            'audio_path' => $body['audio_path'] ?? null,
            'video_path' => $body['video_path'] ?? null,
            'marga_id' => $body['marga_id'] ?? null,
            'daerah' => $body['daerah'] ?? null,
            'narator' => $body['narator'] ?? null,
            'tanggal_rekam' => $body['tanggal_rekam'] ?? null,
            'status' => 'aktif',
            'created_by' => $request->getAttribute('user_id')
        ]);
        
        // Log to entity history
        $this->auditService->log('created', $tradition, $request->getAttribute('user_id'), null, $tradition->toArray());
        
        return $this->jsonResponse($response, ['success' => true, 'data' => $tradition], 201);
    }
    public function getTraditionalKnowledge(Request $request, Response $response): Response
    {
        $query = TraditionalKnowledge::with(['marga', 'creator']);
        $knowledge = $query->orderBy('created_at', 'desc')->get();
        return $this->jsonResponse($response, ['success' => true, 'data' => $knowledge]);
    }
    public function createTraditionalKnowledge(Request $request, Response $response): Response
    {
        $body = $request->getParsedBody() ?? [];
        $knowledge = TraditionalKnowledge::create([
            'kategori' => $body['kategori'],
            'judul' => $body['judul'],
            'deskripsi' => $body['deskripsi'],
            'metode' => $body['metode'] ?? null,
            'bahan' => $body['bahan'] ?? null,
            'alat' => $body['alat'] ?? null,
            'manfaat' => $body['manfaat'] ?? null,
            'larangan' => $body['larangan'] ?? null,
            'marga_id' => $body['marga_id'] ?? null,
            'daerah' => $body['daerah'] ?? null,
            'pengetahuan_dari' => $body['pengetahuan_dari'] ?? null,
            'tanggal_dokumentasi' => $body['tanggal_dokumentasi'] ?? null,
            'foto_path' => $body['foto_path'] ?? null,
            'video_path' => $body['video_path'] ?? null,
            'status' => 'aktif',
            'created_by' => $request->getAttribute('user_id')
        ]);
        
        // Log to entity history
        $this->auditService->log('created', $knowledge, $request->getAttribute('user_id'), null, $knowledge->toArray());
        
        return $this->jsonResponse($response, ['success' => true, 'data' => $knowledge], 201);
    }
    public function getCulturalSites(Request $request, Response $response): Response
    {
        $query = CulturalSite::with(['marga', 'person', 'creator']);
        $sites = $query->orderBy('created_at', 'desc')->get();
        return $this->jsonResponse($response, ['success' => true, 'data' => $sites]);
    }
    public function createCulturalSite(Request $request, Response $response): Response
    {
        $body = $request->getParsedBody() ?? [];
        $site = CulturalSite::create([
            'nama' => $body['nama'],
            'tipe' => $body['tipe'],
            'deskripsi' => $body['deskripsi'] ?? null,
            'alamat' => $body['alamat'] ?? null,
            'kota' => $body['kota'] ?? null,
            'provinsi' => $body['provinsi'] ?? null,
            'latitude' => $body['latitude'] ?? null,
            'longitude' => $body['longitude'] ?? null,
            'marga_id' => $body['marga_id'] ?? null,
            'person_id' => $body['person_id'] ?? null,
            'sejarah' => $body['sejarah'] ?? null,
            'status_konservasi' => 'terjaga',
            'foto_path' => $body['foto_path'] ?? null,
            'created_by' => $request->getAttribute('user_id')
        ]);
        
        // Log to entity history
        $this->auditService->log('created', $site, $request->getAttribute('user_id'), null, $site->toArray());
        
        return $this->jsonResponse($response, ['success' => true, 'data' => $site], 201);
    }
    private function jsonResponse(Response $response, array $data, int $status = 200): Response
    {
        $response->getBody()->write(json_encode($data));
        return $response->withHeader('Content-Type', 'application/json')->withStatus($status);
    }
}
