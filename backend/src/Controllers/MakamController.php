<?php
/**
 * Makam Controller
 * Grave/tomb documentation
 */

namespace App\Controllers;

use App\Models\Makam;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;

class MakamController
{
    public function index(Request $request, Response $response): Response
    {
        $params = $request->getQueryParams();
        $query = Makam::with('person');
        if (!empty($params['lokasi'])) $query->where('lokasi', 'like', '%' . $params['lokasi'] . '%');
        $items = $query->orderBy('created_at', 'desc')->get();
        return $this->jsonResponse($response, ['success' => true, 'data' => $items]);
    }

    public function show(Request $request, Response $response, array $args): Response
    {
        $id = (int)$args['id'];
        $m = Makam::with('person')->find($id);
        if (!$m) return $this->jsonResponse($response, ['success' => false, 'error' => 'Makam tidak ditemukan'], 404);
        return $this->jsonResponse($response, ['success' => true, 'data' => $m]);
    }

    public function store(Request $request, Response $response): Response
    {
        $body = $request->getParsedBody() ?? [];
        $m = Makam::create($body);
        return $this->jsonResponse($response, ['success' => true, 'data' => $m], 201);
    }

    private function jsonResponse(Response $response, array $data, int $status = 200): Response
    {
        $response->getBody()->write(json_encode($data));
        return $response->withHeader('Content-Type', 'application/json')->withStatus($status);
    }
}
