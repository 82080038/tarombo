<?php
/**
 * Document Controller
 * Media and file management
 */

namespace App\Controllers;

use App\Models\Document;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;

class DocumentController
{
    public function index(Request $request, Response $response): Response
    {
        $params = $request->getQueryParams();
        $query = Document::with(['person', 'ceremony', 'punguan'])->whereIn('access_level', ['public', 'restricted']);
        if (!empty($params['type'])) $query->where('document_type', $params['type']);
        if (!empty($params['person_id'])) $query->where('person_id', (int)$params['person_id']);
        $items = $query->orderBy('created_at', 'desc')->get();
        return $this->jsonResponse($response, ['success' => true, 'data' => $items]);
    }

    public function show(Request $request, Response $response, array $args): Response
    {
        $id = (int)$args['id'];
        $doc = Document::with(['person', 'ceremony', 'punguan'])->find($id);
        if (!$doc) return $this->jsonResponse($response, ['success' => false, 'error' => 'Dokumen tidak ditemukan'], 404);
        return $this->jsonResponse($response, ['success' => true, 'data' => $doc]);
    }

    public function store(Request $request, Response $response): Response
    {
        $body = $request->getParsedBody() ?? [];
        $doc = Document::create(array_merge($body, ['uploaded_by' => $request->getAttribute('user_id')]));
        return $this->jsonResponse($response, ['success' => true, 'data' => $doc], 201);
    }

    private function jsonResponse(Response $response, array $data, int $status = 200): Response
    {
        $response->getBody()->write(json_encode($data));
        return $response->withHeader('Content-Type', 'application/json')->withStatus($status);
    }
}
