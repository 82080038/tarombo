<?php

namespace App\Traits;

use Psr\Http\Message\ResponseInterface as Response;

trait ApiResponse
{
    protected function successResponse(Response $response, $data = null, string $message = null, int $status = 200): Response
    {
        $payload = ['success' => true];
        if ($message !== null) $payload['message'] = $message;
        if ($data !== null) $payload['data'] = $data;

        $response->getBody()->write(json_encode($payload));
        return $response->withHeader('Content-Type', 'application/json')->withStatus($status);
    }

    protected function errorResponse(Response $response, string $message, string $code = 'ERROR', int $status = 400, $details = null): Response
    {
        $payload = [
            'success' => false,
            'error' => [
                'code' => $code,
                'message' => $message,
            ]
        ];
        if ($details !== null) $payload['error']['details'] = $details;

        $response->getBody()->write(json_encode($payload));
        return $response->withHeader('Content-Type', 'application/json')->withStatus($status);
    }

    protected function paginatedResponse(Response $response, $items, array $pagination): Response
    {
        $payload = [
            'success' => true,
            'data' => $items,
            'pagination' => $pagination,
        ];

        $response->getBody()->write(json_encode($payload));
        return $response->withHeader('Content-Type', 'application/json');
    }
}
