<?php
/**
 * CORS Middleware
 * Handles Cross-Origin Resource Sharing
 */

namespace App\Middleware;

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Http\Server\RequestHandlerInterface as RequestHandler;

class CorsMiddleware
{
    public function __invoke(Request $request, RequestHandler $handler): Response
    {
        $origin = $_ENV['CORS_ALLOW_ORIGIN'] ?? '*';
        $isWildcard = $origin === '*';

        if ($request->getMethod() === 'OPTIONS') {
            $response = new \Slim\Psr7\Response(204);
        } else {
            $response = $handler->handle($request);
        }

        $response = $response
            ->withHeader('Access-Control-Allow-Origin', $origin)
            ->withHeader('Access-Control-Allow-Headers', 'X-Requested-With, Content-Type, Accept, Origin, Authorization')
            ->withHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, PATCH, OPTIONS');

        if (!$isWildcard) {
            $response = $response->withHeader('Access-Control-Allow-Credentials', 'true');
        }

        return $response;
    }
}
