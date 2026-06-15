<?php
/**
 * Admin Controller
 * Statistics, user management, audit logs
 */

namespace App\Controllers;

use App\Models\Person;
use App\Models\Marga;
use App\Models\Marriage;
use App\Models\User;
use App\Models\AuditLog;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;

class AdminController
{
    /**
     * GET /admin/statistics
     */
    public function statistics(Request $request, Response $response): Response
    {
        $totalPersons = Person::where('status', 'active')->count();
        $totalMarga = Marga::count();
        $totalMarriages = Marriage::count();
        $totalUsers = User::count();

        // Demografi by marga
        $margaStats = Person::selectRaw('marga_id, COUNT(*) as count')
            ->where('status', 'active')
            ->groupBy('marga_id')
            ->with('marga')
            ->get()
            ->map(fn($p) => [
                'marga' => $p->marga?->nama ?? 'Unknown',
                'count' => $p->count
            ]);

        // Demografi by sub-suku
        $subSukuStats = Person::join('marga', 'persons.marga_id', '=', 'marga.id')
            ->selectRaw('marga.sub_suku, COUNT(*) as count')
            ->where('persons.status', 'active')
            ->groupBy('marga.sub_suku')
            ->get();

        // Gender distribution
        $genderStats = Person::where('status', 'active')
            ->selectRaw('jenis_kelamin, COUNT(*) as count')
            ->groupBy('jenis_kelamin')
            ->get();

        // Recent audit logs
        $recentLogs = AuditLog::orderBy('created_at', 'desc')
            ->limit(20)
            ->get();

        $response->getBody()->write(json_encode([
            'success' => true,
            'data' => [
                'overview' => [
                    'total_persons' => $totalPersons,
                    'total_marga' => $totalMarga,
                    'total_marriages' => $totalMarriages,
                    'total_users' => $totalUsers,
                ],
                'marga_distribution' => $margaStats,
                'sub_suku_distribution' => $subSukuStats,
                'gender_distribution' => $genderStats,
                'recent_logs' => $recentLogs,
            ]
        ]));

        return $response->withHeader('Content-Type', 'application/json');
    }

    /**
     * GET /admin/users
     */
    public function users(Request $request, Response $response): Response
    {
        $users = User::with('person')->get();

        $response->getBody()->write(json_encode([
            'success' => true,
            'data' => $users
        ]));

        return $response->withHeader('Content-Type', 'application/json');
    }

    /**
     * PUT /admin/users/{id}/role
     */
    public function updateUserRole(Request $request, Response $response, array $args): Response
    {
        $id = (int)$args['id'];
        $body = $request->getParsedBody() ?? [];
        $role = $body['role'] ?? null;

        $user = User::find($id);
        if (!$user) {
            return $this->jsonResponse($response, ['success' => false, 'error' => 'User not found'], 404);
        }

        if (!in_array($role, ['guest', 'user', 'verified', 'tetua', 'punguan_admin', 'admin'])) {
            return $this->jsonResponse($response, ['success' => false, 'error' => 'Invalid role'], 400);
        }

        $user->role = $role;
        $user->save();

        return $this->jsonResponse($response, ['success' => true, 'message' => 'Role updated']);
    }

    private function jsonResponse(Response $response, array $data, int $status = 200): Response
    {
        $response->getBody()->write(json_encode($data));
        return $response->withHeader('Content-Type', 'application/json')->withStatus($status);
    }
}
