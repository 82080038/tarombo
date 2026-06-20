<?php
/**
 * Auth Middleware
 * Handles JWT authentication
 */

namespace App\Middleware;

use Firebase\JWT\JWT;
use Firebase\JWT\Key;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Http\Server\RequestHandlerInterface as RequestHandler;

class AuthMiddleware
{
    private string $secretKey;
    
    public function __construct()
    {
        $this->secretKey = $_ENV['JWT_SECRET'] ?? throw new \RuntimeException('JWT_SECRET environment variable is not set');
    }
    
    public function __invoke(Request $request, RequestHandler $handler): Response
    {
        $authHeader = $request->getHeaderLine('Authorization');
        
        if (!$authHeader) {
            return $this->unauthorizedResponse('Authorization header missing');
        }
        
        if (!preg_match('/Bearer\s+(.*)$/i', $authHeader, $matches)) {
            return $this->unauthorizedResponse('Invalid authorization header format');
        }
        
        $token = $matches[1];
        
        try {
            $decoded = JWT::decode($token, new Key($this->secretKey, 'HS256'));
            
            // Add user info to request attributes
            $request = $request->withAttribute('user_id', $decoded->sub);
            $request = $request->withAttribute('user_role', $decoded->role ?? 'user');
            
            return $handler->handle($request);
        } catch (\Exception $e) {
            return $this->unauthorizedResponse('Invalid or expired token');
        }
    }
    
    private function unauthorizedResponse(string $message): Response
    {
        $response = new \Slim\Psr7\Response();
        $response->getBody()->write(json_encode([
            'error' => $message,
            'code' => 'UNAUTHORIZED'
        ]));
        
        return $response
            ->withHeader('Content-Type', 'application/json')
            ->withStatus(401);
    }
}
