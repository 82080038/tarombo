<?php
/**
 * Asset Controller
 * Manages family assets and inheritance records
 */

namespace App\Controllers;

use App\Models\Asset;
use App\Models\InheritanceRecord;
use App\Models\Person;
use App\Models\Document;
use App\Services\AuditService;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;

class AssetController
{
    private AuditService $auditService;

    public function __construct()
    {
        $this->auditService = new AuditService();
    }
    public function index(Request $request, Response $response): Response
    {
        $query = Asset::with(['pemilik', 'marga']);
        
        // Filter by type
        $tipe = $request->getQueryParams()['tipe'] ?? null;
        if ($tipe) {
            $query->where('tipe', $tipe);
        }
        
        // Filter by marga
        $margaId = $request->getQueryParams()['marga_id'] ?? null;
        if ($margaId) {
            $query->where('marga_id', $margaId);
        }
        
        // Filter by owner
        $pemilikId = $request->getQueryParams()['pemilik_id'] ?? null;
        if ($pemilikId) {
            $query->where('pemilik_saat_ini_id', $pemilikId);
        }
        
        // Filter by status
        $status = $request->getQueryParams()['status'] ?? null;
        if ($status) {
            $query->where('status', $status);
        }
        
        $page = max(1, (int)($request->getQueryParams()['page'] ?? 1));
        $limit = min(100, max(1, (int)($request->getQueryParams()['limit'] ?? 20)));
        $total = $query->count();
        $assets = $query->offset(($page - 1) * $limit)->limit($limit)
            ->orderBy('created_at', 'desc')->get();
        
        return $this->jsonResponse($response, [
            'success' => true,
            'data' => $assets,
            'pagination' => [
                'page' => $page,
                'limit' => $limit,
                'total' => $total,
                'total_pages' => (int)ceil($total / $limit)
            ]
        ]);
    }
    
    public function show(Request $request, Response $response, array $args): Response
    {
        $id = (int)$args['id'];
        $asset = Asset::with(['pemilik', 'marga', 'inheritanceRecords.pemilikLama', 'inheritanceRecords.pemilikBaru', 'inheritanceRecords.saksi'])
            ->find($id);
        
        if (!$asset) {
            return $this->jsonResponse($response, [
                'success' => false,
                'error' => ['code' => 'ASSET_NOT_FOUND', 'message' => 'Asset not found']
            ], 404);
        }
        
        return $this->jsonResponse($response, [
            'success' => true,
            'data' => $asset
        ]);
    }
    
    public function store(Request $request, Response $response): Response
    {
        $body = $request->getParsedBody() ?? [];
        
        $asset = Asset::create([
            'nama' => $body['nama'] ?? '',
            'tipe' => $body['tipe'] ?? 'lainnya',
            'deskripsi' => $body['deskripsi'] ?? null,
            'nilai_estimasi' => $body['nilai_estimasi'] ?? null,
            'tanggal_perolehan' => $body['tanggal_perolehan'] ?? null,
            'cara_perolehan' => $body['cara_perolehan'] ?? 'lainnya',
            'lokasi' => $body['lokasi'] ?? null,
            'latitude' => $body['latitude'] ?? null,
            'longitude' => $body['longitude'] ?? null,
            'foto_path' => $body['foto_path'] ?? null,
            'status' => $body['status'] ?? 'aktif',
            'pemilik_saat_ini_id' => $body['pemilik_saat_ini_id'] ?? null,
            'marga_id' => $body['marga_id'] ?? null,
            'created_by' => $request->getAttribute('user_id')
        ]);
        
        // Log to entity history
        $this->auditService->log('created', $asset, $request->getAttribute('user_id'), null, $asset->toArray());
        
        return $this->jsonResponse($response, [
            'success' => true,
            'data' => $asset,
            'message' => 'Asset created successfully'
        ], 201);
    }
    
    public function update(Request $request, Response $response, array $args): Response
    {
        $id = (int)$args['id'];
        $body = $request->getParsedBody() ?? [];
        
        $asset = Asset::find($id);
        if (!$asset) {
            return $this->jsonResponse($response, [
                'success' => false,
                'error' => ['code' => 'ASSET_NOT_FOUND', 'message' => 'Asset not found']
            ], 404);
        }
        
        $oldValues = $asset->toArray();
        
        $asset->update([
            'nama' => $body['nama'] ?? $asset->nama,
            'tipe' => $body['tipe'] ?? $asset->tipe,
            'deskripsi' => $body['deskripsi'] ?? $asset->deskripsi,
            'nilai_estimasi' => $body['nilai_estimasi'] ?? $asset->nilai_estimasi,
            'tanggal_perolehan' => $body['tanggal_perolehan'] ?? $asset->tanggal_perolehan,
            'cara_perolehan' => $body['cara_perolehan'] ?? $asset->cara_perolehan,
            'lokasi' => $body['lokasi'] ?? $asset->lokasi,
            'latitude' => $body['latitude'] ?? $asset->latitude,
            'longitude' => $body['longitude'] ?? $asset->longitude,
            'foto_path' => $body['foto_path'] ?? $asset->foto_path,
            'status' => $body['status'] ?? $asset->status,
            'pemilik_saat_ini_id' => $body['pemilik_saat_ini_id'] ?? $asset->pemilik_saat_ini_id,
            'marga_id' => $body['marga_id'] ?? $asset->marga_id
        ]);
        
        // Log to entity history
        $this->auditService->log('updated', $asset, $request->getAttribute('user_id'), $oldValues, $asset->toArray());
        
        return $this->jsonResponse($response, [
            'success' => true,
            'data' => $asset,
            'message' => 'Asset updated successfully'
        ]);
    }
    
    public function destroy(Request $request, Response $response, array $args): Response
    {
        $id = (int)$args['id'];
        $asset = Asset::find($id);
        
        if (!$asset) {
            return $this->jsonResponse($response, [
                'success' => false,
                'error' => ['code' => 'ASSET_NOT_FOUND', 'message' => 'Asset not found']
            ], 404);
        }
        
        $oldValues = $asset->toArray();
        $asset->delete();
        
        // Log to entity history
        $this->auditService->log('deleted', $asset, $request->getAttribute('user_id'), $oldValues, null);
        
        return $this->jsonResponse($response, [
            'success' => true,
            'message' => 'Asset deleted successfully'
        ]);
    }
    
    public function transferOwnership(Request $request, Response $response, array $args): Response
    {
        $id = (int)$args['id'];
        $body = $request->getParsedBody() ?? [];
        
        $asset = Asset::find($id);
        if (!$asset) {
            return $this->jsonResponse($response, [
                'success' => false,
                'error' => ['code' => 'ASSET_NOT_FOUND', 'message' => 'Asset not found']
            ], 404);
        }
        
        $pemilikLamaId = $asset->pemilik_saat_ini_id;
        $pemilikBaruId = $body['pemilik_baru_id'] ?? null;
        
        if (!$pemilikBaruId) {
            return $this->jsonResponse($response, [
                'success' => false,
                'error' => ['code' => 'INVALID_INPUT', 'message' => 'New owner ID is required']
            ], 400);
        }
        
        // Create inheritance record
        $inheritanceRecord = InheritanceRecord::create([
            'asset_id' => $id,
            'pemilik_lama_id' => $pemilikLamaId,
            'pemilik_baru_id' => $pemilikBaruId,
            'tanggal_transfer' => $body['tanggal_transfer'] ?? now(),
            'cara_transfer' => $body['cara_transfer'] ?? 'warisan_adat',
            'alasan_transfer' => $body['alasan_transfer'] ?? null,
            'saksi_id' => $body['saksi_id'] ?? null,
            'dokumen_id' => $body['dokumen_id'] ?? null,
            'catatan' => $body['catatan'] ?? null
        ]);
        
        // Update asset owner
        $asset->pemilik_saat_ini_id = $pemilikBaruId;
        $asset->save();
        
        return $this->jsonResponse($response, [
            'success' => true,
            'data' => [
                'asset' => $asset,
                'inheritance_record' => $inheritanceRecord
            ],
            'message' => 'Asset ownership transferred successfully'
        ]);
    }
    
    public function getInheritanceHistory(Request $request, Response $response, array $args): Response
    {
        $id = (int)$args['id'];
        $records = InheritanceRecord::with(['pemilikLama', 'pemilikBaru', 'saksi'])
            ->where('asset_id', $id)
            ->orderBy('created_at', 'desc')
            ->get();
        
        return $this->jsonResponse($response, [
            'success' => true,
            'data' => $records
        ]);
    }
    
    private function jsonResponse(Response $response, array $data, int $status = 200): Response
    {
        $response->getBody()->write(json_encode($data));
        return $response
            ->withHeader('Content-Type', 'application/json')
            ->withStatus($status);
    }
}
