<?php
/**
 * Punguan Controller
 * Organization, members, and contributions
 */

namespace App\Controllers;

use App\Models\Punguan;
use App\Models\PunguanMember;
use App\Models\Iuran;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;

class PunguanController
{
    public function index(Request $request, Response $response): Response
    {
        $items = Punguan::with(['marga', 'ketua'])->where('status', 'active')->get();
        return $this->jsonResponse($response, ['success' => true, 'data' => $items]);
    }

    public function show(Request $request, Response $response, array $args): Response
    {
        $id = (int)$args['id'];
        $p = Punguan::with(['marga', 'ketua', 'members.person', 'iuran'])->find($id);
        if (!$p) return $this->jsonResponse($response, ['success' => false, 'error' => 'Punguan tidak ditemukan'], 404);
        return $this->jsonResponse($response, ['success' => true, 'data' => $p]);
    }

    public function members(Request $request, Response $response, array $args): Response
    {
        $id = (int)$args['id'];
        $members = PunguanMember::with('person')->where('punguan_id', $id)->where('status', 'active')->get();
        return $this->jsonResponse($response, ['success' => true, 'data' => $members]);
    }

    public function store(Request $request, Response $response): Response
    {
        $body = $request->getParsedBody() ?? [];
        $p = Punguan::create($body);
        return $this->jsonResponse($response, ['success' => true, 'data' => $p], 201);
    }

    private function jsonResponse(Response $response, array $data, int $status = 200): Response
    {
        $response->getBody()->write(json_encode($data));
        return $response->withHeader('Content-Type', 'application/json')->withStatus($status);
    }
}
