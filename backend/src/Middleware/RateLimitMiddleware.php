<?php
/**
 * Rate Limit Middleware
 * Protects authentication endpoints from brute force attacks
 */

namespace App\Middleware;

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Http\Server\RequestHandlerInterface as RequestHandler;

class RateLimitMiddleware
{
    private array $rateLimits = [
        '/api/v1/auth/login' => ['max_attempts' => 5, 'window' => 300], // 5 attempts per 5 minutes
        '/api/v1/auth/register' => ['max_attempts' => 3, 'window' => 3600], // 3 attempts per hour
    ];
    
    private string $cacheKeyPrefix = 'rate_limit:';
    
    public function __invoke(Request $request, RequestHandler $handler): Response
    {
        $uri = $request->getUri()->getPath();
        $ipAddress = $this->getClientIp($request);
        
        // Check if this endpoint has rate limiting
        if (!isset($this->rateLimits[$uri])) {
            return $handler->handle($request);
        }
        
        $limit = $this->rateLimits[$uri];
        $key = $this->cacheKeyPrefix . $uri . ':' . $ipAddress;
        
        // Get current attempts from cache (using session as simple cache)
        $attempts = $this->getAttempts($key);
        
        if ($attempts >= $limit['max_attempts']) {
            return $this->rateLimitExceededResponse($limit['window']);
        }
        
        // Increment attempts
        $this->incrementAttempts($key, $limit['window']);
        
        // Add rate limit headers to response
        $response = $handler->handle($request);
        
        $remaining = $limit['max_attempts'] - ($attempts + 1);
        $response = $response->withHeader('X-RateLimit-Limit', (string)$limit['max_attempts']);
        $response = $response->withHeader('X-RateLimit-Remaining', (string)$remaining);
        $response = $response->withHeader('X-RateLimit-Reset', (string)(time() + $limit['window']));
        
        return $response;
    }
    
    private function getClientIp(Request $request): string
    {
        $serverParams = $request->getServerParams();
        
        // Check for forwarded IP (behind proxy)
        if (isset($serverParams['HTTP_X_FORWARDED_FOR'])) {
            return $serverParams['HTTP_X_FORWARDED_FOR'];
        }
        
        return $serverParams['REMOTE_ADDR'] ?? 'unknown';
    }
    
    private function getAttempts(string $key): int
    {
        // Simple implementation using session
        if (session_status() === PHP_SESSION_NONE) {
            session_start();
        }
        
        $data = $_SESSION[$key] ?? null;
        
        if (!$data) {
            return 0;
        }
        
        // Check if window has expired
        if (time() > $data['expires_at']) {
            unset($_SESSION[$key]);
            return 0;
        }
        
        return $data['attempts'];
    }
    
    private function incrementAttempts(string $key, int $window): void
    {
        if (session_status() === PHP_SESSION_NONE) {
            session_start();
        }
        
        $data = $_SESSION[$key] ?? null;
        
        if (!$data || time() > $data['expires_at']) {
            $_SESSION[$key] = [
                'attempts' => 1,
                'expires_at' => time() + $window
            ];
        } else {
            $_SESSION[$key]['attempts']++;
        }
    }
    
    private function rateLimitExceededResponse(int $retryAfter): Response
    {
        $response = new \Slim\Psr7\Response();
        $response->getBody()->write(json_encode([
            'error' => 'Rate limit exceeded',
            'message' => 'Too many attempts. Please try again later.',
            'retry_after' => $retryAfter
        ]));
        
        return $response
            ->withHeader('Content-Type', 'application/json')
            ->withHeader('Retry-After', (string)$retryAfter)
            ->withStatus(429);
    }
}
