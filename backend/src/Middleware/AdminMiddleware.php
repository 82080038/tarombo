<?php
/**
 * Admin Middleware
 * Checks if user has admin role
 */

namespace App\Middleware;

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Http\Server\RequestHandlerInterface as RequestHandler;

class AdminMiddleware
{
    public function __invoke(Request $request, RequestHandler $handler): Response
    {
        $userRole = $request->getAttribute('user_role');
        
        // Allow admin, punguan_admin, and tetua
        if (!in_array($userRole, ['admin', 'punguan_admin', 'tetua'])) {
            return $this->forbiddenResponse('Admin access required');
        }
        
        return $handler->handle($request);
    }
    
    private function forbiddenResponse(string $message): Response
    {
        $response = new \Slim\Psr7\Response();
        $response->getBody()->write(json_encode([
            'success' => false,
            'error' => ['code' => 'FORBIDDEN', 'message' => $message]
        ]));
        
        return $response
            ->withHeader('Content-Type', 'application/json')
            ->withStatus(403);
    }
}
