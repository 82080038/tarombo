<?php
/**
 * Marga Controller
 * Handles CRUD operations for marga (clans)
 */

namespace App\Controllers;

use App\Models\Marga;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;

class MargaController
{
    /**
     * List all marga
     * GET /api/v1/marga
     */
    public function index(Request $request, Response $response): Response
    {
        $query = Marga::query()->where('status', 'active');
        
        // Filter by sub-suku
        if ($subSuku = $request->getQueryParams()['sub_suku'] ?? null) {
            $query->bySubSuku($subSuku);
        }
        
        $marga = $query->orderBy('nama')->get();
        
        $response->getBody()->write(json_encode([
            'data' => $marga->toArray(),
            'total' => $marga->count()
        ]));
        
        return $response->withHeader('Content-Type', 'application/json');
    }
    
    /**
     * Get marga detail
     * GET /api/v1/marga/{id}
     */
    public function show(Request $request, Response $response, array $args): Response
    {
        $id = (int) $args['id'];
        
        $marga = Marga::with('persons')->find($id);
        
        if (!$marga) {
            $response->getBody()->write(json_encode([
                'error' => 'Marga not found',
                'code' => 'MARGA_NOT_FOUND'
            ]));
            return $response
                ->withHeader('Content-Type', 'application/json')
                ->withStatus(404);
        }
        
        $response->getBody()->write(json_encode([
            'data' => $marga->toArray(),
            'persons_count' => $marga->active_persons_count
        ]));
        
        return $response->withHeader('Content-Type', 'application/json');
    }
}
