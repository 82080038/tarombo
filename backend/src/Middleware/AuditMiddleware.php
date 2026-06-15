<?php
/**
 * Audit Middleware
 * Logs all sensitive operations for security monitoring
 */

namespace App\Middleware;

use App\Services\AuditService;
use Illuminate\Support\Facades\DB;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Http\Server\RequestHandlerInterface as RequestHandler;

class AuditMiddleware
{
    private AuditService $auditService;
    private bool $tableExists;
    private array $sensitiveEndpoints = [
        '/api/v1/finance',
        '/api/v1/admin',
        '/api/v1/backup',
        '/api/v1/auth/login',
        '/api/v1/auth/register',
    ];

    public function __construct()
    {
        $this->auditService = new AuditService();
        $this->tableExists = $this->checkTableExists();
    }
    
    private function checkTableExists(): bool
    {
        try {
            // Check if DB facade is available
            if (!class_exists('DB') || !method_exists('DB', 'select')) {
                return false;
            }
            $result = DB::select("SHOW TABLES LIKE 'security_audit_log'");
            return !empty($result);
        } catch (\Exception $e) {
            return false;
        }
    }

    public function __invoke(Request $request, RequestHandler $handler): Response
    {
        // Skip logging if table doesn't exist yet
        if (!$this->tableExists) {
            return $handler->handle($request);
        }
        
        $uri = $request->getUri()->getPath();
        $method = $request->getMethod();
        $userId = $request->getAttribute('user_id');
        
        // Check if this is a sensitive endpoint
        $isSensitive = $this->isSensitiveEndpoint($uri, $method);
        
        // Only log sensitive endpoints, not all GET requests
        if ($isSensitive && $method !== 'GET') {
            try {
                $this->auditService->logSecurityEvent(
                    'API_ACCESS',
                    $userId,
                    $uri,
                    $method,
                    $request->getServerParams()['REMOTE_ADDR'] ?? 'unknown',
                    $request->getHeaderLine('User-Agent')
                );
            } catch (\Exception $e) {
                // Silently fail if logging fails
                error_log('Audit logging failed: ' . $e->getMessage());
            }
        }
        
        $response = $handler->handle($request);
        
        // Log sensitive operations (POST, PUT, DELETE)
        if ($isSensitive && in_array($method, ['POST', 'PUT', 'DELETE'])) {
            $statusCode = $response->getStatusCode();
            
            try {
                $this->auditService->logSecurityEvent(
                    'SENSITIVE_OPERATION',
                    $userId,
                    $uri,
                    $method,
                    $request->getServerParams()['REMOTE_ADDR'] ?? 'unknown',
                    $request->getHeaderLine('User-Agent'),
                    [
                        'status_code' => $statusCode,
                        'success' => $statusCode < 400
                    ]
                );
            } catch (\Exception $e) {
                // Silently fail if logging fails
                error_log('Audit logging failed: ' . $e->getMessage());
            }
        }
        
        // Return response without any modification
        return $response;
    }

    private function isSensitiveEndpoint(string $uri, string $method): bool
    {
        foreach ($this->sensitiveEndpoints as $endpoint) {
            if (str_starts_with($uri, $endpoint)) {
                return true;
            }
        }
        
        // Only consider write operations as sensitive
        // GET requests are not considered sensitive to avoid response duplication
        return false;
    }
}
