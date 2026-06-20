<?php
/**
 * Auth Controller
 * Handles authentication (login, register, me, logout)
 */

namespace App\Controllers;

use App\Models\User;
use App\Models\Person;
use App\Services\EmailService;
use Firebase\JWT\JWT;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Illuminate\Support\Facades\DB;

class AuthController
{
    private string $secretKey;
    private int $tokenExpiry;
    
    public function __construct()
    {
        $this->secretKey = $_ENV['JWT_SECRET'] ?? throw new \RuntimeException('JWT_SECRET environment variable is not set');
        $this->tokenExpiry = 86400; // 24 hours
    }
    
    /**
     * POST /auth/login
     * Login user and return JWT token
     */
    public function login(Request $request, Response $response): Response
    {
        $body = $request->getParsedBody() ?? [];
        $email = $body['email'] ?? '';
        $password = $body['password'] ?? '';
        
        // Validate input
        if (empty($email) || empty($password)) {
            return $this->jsonResponse($response, [
                'success' => false,
                'error' => [
                    'code' => 'INVALID_INPUT',
                    'message' => 'Email dan password wajib diisi'
                ]
            ], 400);
        }
        
        // Find user
        $user = User::where('email', $email)
            ->where('status', 'active')
            ->first();
        
        if (!$user) {
            return $this->jsonResponse($response, [
                'success' => false,
                'error' => [
                    'code' => 'INVALID_CREDENTIALS',
                    'message' => 'Email atau password tidak valid'
                ]
            ], 401);
        }
        
        // Verify password
        if (!password_verify($password, $user->password)) {
            return $this->jsonResponse($response, [
                'success' => false,
                'error' => [
                    'code' => 'INVALID_CREDENTIALS',
                    'message' => 'Email atau password tidak valid'
                ]
            ], 401);
        }
        
        // Generate JWT
        $issuedAt = time();
        $expire = $issuedAt + $this->tokenExpiry;
        
        $payload = [
            'iat' => $issuedAt,
            'exp' => $expire,
            'sub' => $user->id,
            'email' => $user->email,
            'role' => $user->role,
            'name' => $user->nama
        ];
        
        $token = JWT::encode($payload, $this->secretKey, 'HS256');
        
        return $this->jsonResponse($response, [
            'success' => true,
            'data' => [
                'access_token' => $token,
                'token_type' => 'Bearer',
                'expires_in' => $this->tokenExpiry,
                'user' => [
                    'id' => $user->id,
                    'email' => $user->email,
                    'nama' => $user->nama,
                    'role' => $user->role,
                    'person_id' => $user->person_id
                ]
            ]
        ]);
    }
    
    /**
     * POST /auth/register
     * Register new user
     */
    public function register(Request $request, Response $response): Response
    {
        $body = $request->getParsedBody() ?? [];
        
        $email = $body['email'] ?? '';
        $password = $body['password'] ?? '';
        $nama = $body['nama'] ?? '';
        $personId = $body['person_id'] ?? null;
        
        // Validate
        if (empty($email) || empty($password) || empty($nama)) {
            return $this->jsonResponse($response, [
                'success' => false,
                'error' => [
                    'code' => 'INVALID_INPUT',
                    'message' => 'Email, password, dan nama wajib diisi'
                ]
            ], 400);
        }
        
        if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
            return $this->jsonResponse($response, [
                'success' => false,
                'error' => [
                    'code' => 'INVALID_EMAIL',
                    'message' => 'Format email tidak valid'
                ]
            ], 400);
        }
        
        if (strlen($password) < 6) {
            return $this->jsonResponse($response, [
                'success' => false,
                'error' => [
                    'code' => 'WEAK_PASSWORD',
                    'message' => 'Password minimal 6 karakter'
                ]
            ], 400);
        }
        
        // Check email uniqueness
        $existing = User::where('email', $email)->first();
        if ($existing) {
            return $this->jsonResponse($response, [
                'success' => false,
                'error' => [
                    'code' => 'EMAIL_EXISTS',
                    'message' => 'Email sudah terdaftar'
                ]
            ], 409);
        }
        
        // Create user
        $user = User::create([
            'email' => $email,
            'password' => password_hash($password, PASSWORD_BCRYPT),
            'nama' => $nama,
            'role' => 'user',
            'person_id' => $personId,
            'status' => 'active'
        ]);
        
        return $this->jsonResponse($response, [
            'success' => true,
            'data' => [
                'user_id' => $user->id,
                'email' => $user->email,
                'nama' => $user->nama,
                'role' => $user->role,
                'message' => 'Akun berhasil dibuat'
            ]
        ], 201);
    }
    
    /**
     * GET /auth/me
     * Get current authenticated user
     */
    public function me(Request $request, Response $response): Response
    {
        $userId = $request->getAttribute('user_id');
        
        if (!$userId) {
            return $this->jsonResponse($response, [
                'success' => false,
                'error' => [
                    'code' => 'UNAUTHORIZED',
                    'message' => 'Tidak terautentikasi'
                ]
            ], 401);
        }
        
        $user = User::with('person')->find($userId);
        
        if (!$user) {
            return $this->jsonResponse($response, [
                'success' => false,
                'error' => [
                    'code' => 'USER_NOT_FOUND',
                    'message' => 'User tidak ditemukan'
                ]
            ], 404);
        }
        
        return $this->jsonResponse($response, [
            'success' => true,
            'data' => [
                'id' => $user->id,
                'email' => $user->email,
                'nama' => $user->nama,
                'role' => $user->role,
                'status' => $user->status,
                'person_id' => $user->person_id,
                'person' => $user->person ? [
                    'id' => $user->person->id,
                    'nama' => $user->person->nama
                ] : null
            ]
        ]);
    }
    
    /**
     * POST /auth/logout
     * Logout (client should remove token)
     */
    public function logout(Request $request, Response $response): Response
    {
        return $this->jsonResponse($response, [
            'success' => true,
            'message' => 'Logout berhasil'
        ]);
    }
    
    /**
     * Quick login for development
     * POST /auth/quick-login
     */
    public function quickLogin(Request $request, Response $response): Response
    {
        // Only available in development AND from localhost
        if (($_ENV['APP_ENV'] ?? 'production') !== 'development') {
            return $this->jsonResponse($response, [
                'success' => false,
                'error' => [
                    'code' => 'FORBIDDEN',
                    'message' => 'Quick login hanya tersedia di mode development'
                ]
            ], 403);
        }
        
        $clientIp = $request->getServerParams()['REMOTE_ADDR'] ?? '';
        $allowedIps = ['127.0.0.1', '::1', 'localhost'];
        if (!in_array($clientIp, $allowedIps)) {
            return $this->jsonResponse($response, [
                'success' => false,
                'error' => [
                    'code' => 'FORBIDDEN',
                    'message' => 'Quick login hanya tersedia dari localhost'
                ]
            ], 403);
        }
        
        $body = $request->getParsedBody() ?? [];
        $role = $body['role'] ?? 'admin';
        
        // Find first user with the given role or any user
        $user = User::where('status', 'active')
            ->when($role !== 'any', function ($query) use ($role) {
                return $query->where('role', $role);
            })
            ->first();
        
        if (!$user) {
            $user = User::where('status', 'active')->first();
        }
        
        if (!$user) {
            return $this->jsonResponse($response, [
                'success' => false,
                'error' => [
                    'code' => 'NO_USER',
                    'message' => 'Tidak ada user yang tersedia'
                ]
            ], 404);
        }
        
        // Generate JWT
        $issuedAt = time();
        $expire = $issuedAt + $this->tokenExpiry;
        
        $payload = [
            'iat' => $issuedAt,
            'exp' => $expire,
            'sub' => $user->id,
            'email' => $user->email,
            'role' => $user->role,
            'name' => $user->nama
        ];
        
        $token = JWT::encode($payload, $this->secretKey, 'HS256');
        
        return $this->jsonResponse($response, [
            'success' => true,
            'data' => [
                'access_token' => $token,
                'token_type' => 'Bearer',
                'expires_in' => $this->tokenExpiry,
                'quick_login' => true,
                'user' => [
                    'id' => $user->id,
                    'email' => $user->email,
                    'nama' => $user->nama,
                    'role' => $user->role,
                    'person_id' => $user->person_id
                ]
            ]
        ]);
    }

    /**
     * POST /auth/forgot-password
     * Request password reset — generates token and stores in DB
     */
    public function forgotPassword(Request $request, Response $response): Response
    {
        $body = $request->getParsedBody() ?? [];
        $email = trim($body['email'] ?? '');

        if (empty($email) || !filter_var($email, FILTER_VALIDATE_EMAIL)) {
            return $this->jsonResponse($response, [
                'success' => false,
                'error' => ['code' => 'INVALID_EMAIL', 'message' => 'Email tidak valid']
            ], 400);
        }

        $user = User::where('email', $email)->where('status', 'active')->first();

        // Always return success to prevent email enumeration
        if (!$user) {
            return $this->jsonResponse($response, [
                'success' => true,
                'message' => 'Jika email terdaftar, link reset password telah dikirim'
            ]);
        }

        // Generate reset token (JWT with short expiry)
        $issuedAt = time();
        $expire = $issuedAt + 3600; // 1 hour

        $payload = [
            'iat' => $issuedAt,
            'exp' => $expire,
            'sub' => $user->id,
            'type' => 'password_reset',
            'email' => $user->email
        ];

        $resetToken = JWT::encode($payload, $this->secretKey, 'HS256');

        // Store token hash in DB
        DB::table('password_resets')->updateOrInsert(
            ['email' => $user->email],
            [
                'token' => hash('sha256', $resetToken),
                'created_at' => date('Y-m-d H:i:s')
            ]
        );

        // Send email if EmailService is available
        try {
            $emailService = new EmailService();
            $emailService->sendPasswordReset($user->email, $resetToken);
        } catch (\Exception $e) {
            // Email sending failed, but we don't expose this to user
            error_log('Password reset email failed: ' . $e->getMessage());
        }

        return $this->jsonResponse($response, [
            'success' => true,
            'message' => 'Jika email terdaftar, link reset password telah dikirim'
        ]);
    }

    /**
     * POST /auth/reset-password
     * Reset password using token
     */
    public function resetPassword(Request $request, Response $response): Response
    {
        $body = $request->getParsedBody() ?? [];
        $token = trim($body['token'] ?? '');
        $newPassword = $body['password'] ?? '';

        if (empty($token) || strlen($newPassword) < 8) {
            return $this->jsonResponse($response, [
                'success' => false,
                'error' => ['code' => 'INVALID_INPUT', 'message' => 'Token dan password (min 8 karakter) wajib diisi']
            ], 400);
        }

        // Verify token
        try {
            $decoded = JWT::decode($token, new \Firebase\JWT\Key($this->secretKey, 'HS256'));
        } catch (\Exception $e) {
            return $this->jsonResponse($response, [
                'success' => false,
                'error' => ['code' => 'INVALID_TOKEN', 'message' => 'Token tidak valid atau sudah kadaluarsa']
            ], 400);
        }

        if (($decoded->type ?? '') !== 'password_reset') {
            return $this->jsonResponse($response, [
                'success' => false,
                'error' => ['code' => 'INVALID_TOKEN', 'message' => 'Token type tidak valid']
            ], 400);
        }

        // Check token in DB
        $resetRecord = DB::table('password_resets')
            ->where('email', $decoded->email)
            ->where('token', hash('sha256', $token))
            ->first();

        if (!$resetRecord) {
            return $this->jsonResponse($response, [
                'success' => false,
                'error' => ['code' => 'INVALID_TOKEN', 'message' => 'Token tidak ditemukan atau sudah digunakan']
            ], 400);
        }

        // Check token age (max 1 hour)
        $createdAt = strtotime($resetRecord->created_at);
        if (time() - $createdAt > 3600) {
            DB::table('password_resets')->where('email', $decoded->email)->delete();
            return $this->jsonResponse($response, [
                'success' => false,
                'error' => ['code' => 'TOKEN_EXPIRED', 'message' => 'Token sudah kadaluarsa']
            ], 400);
        }

        // Update password
        $user = User::where('email', $decoded->email)->first();
        if (!$user) {
            return $this->jsonResponse($response, [
                'success' => false,
                'error' => ['code' => 'USER_NOT_FOUND', 'message' => 'User tidak ditemukan']
            ], 404);
        }

        $user->password = password_hash($newPassword, PASSWORD_BCRYPT);
        $user->save();

        // Delete used token
        DB::table('password_resets')->where('email', $decoded->email)->delete();

        return $this->jsonResponse($response, [
            'success' => true,
            'message' => 'Password berhasil direset'
        ]);
    }

    /**
     * POST /auth/verify-email
     * Verify email with token
     */
    public function verifyEmail(Request $request, Response $response): Response
    {
        $body = $request->getParsedBody() ?? [];
        $token = trim($body['token'] ?? '');

        if (empty($token)) {
            return $this->jsonResponse($response, [
                'success' => false,
                'error' => ['code' => 'INVALID_INPUT', 'message' => 'Token wajib diisi']
            ], 400);
        }

        try {
            $decoded = JWT::decode($token, new \Firebase\JWT\Key($this->secretKey, 'HS256'));
        } catch (\Exception $e) {
            return $this->jsonResponse($response, [
                'success' => false,
                'error' => ['code' => 'INVALID_TOKEN', 'message' => 'Token tidak valid atau sudah kadaluarsa']
            ], 400);
        }

        if (($decoded->type ?? '') !== 'email_verify') {
            return $this->jsonResponse($response, [
                'success' => false,
                'error' => ['code' => 'INVALID_TOKEN', 'message' => 'Token type tidak valid']
            ], 400);
        }

        $user = User::find($decoded->sub);
        if (!$user) {
            return $this->jsonResponse($response, [
                'success' => false,
                'error' => ['code' => 'USER_NOT_FOUND', 'message' => 'User tidak ditemukan']
            ], 404);
        }

        if ($user->email_verified_at !== null) {
            return $this->jsonResponse($response, [
                'success' => true,
                'message' => 'Email sudah diverifikasi sebelumnya'
            ]);
        }

        $user->email_verified_at = date('Y-m-d H:i:s');
        $user->save();

        return $this->jsonResponse($response, [
            'success' => true,
            'message' => 'Email berhasil diverifikasi'
        ]);
    }

    private function jsonResponse(Response $response, array $data, int $status = 200): Response
    {
        $response->getBody()->write(json_encode($data));
        return $response
            ->withHeader('Content-Type', 'application/json')
            ->withStatus($status);
    }
}
