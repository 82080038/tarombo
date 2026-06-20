<?php
/**
 * Finance Controller
 * Manages punguan financial operations
 */

namespace App\Controllers;

use App\Models\Transaction;
use App\Models\Budget;
use App\Models\Iuran;
use App\Services\AuditService;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;

class FinanceController
{
    private AuditService $auditService;

    public function __construct()
    {
        $this->auditService = new AuditService();
    }
    public function getTransactions(Request $request, Response $response): Response
    {
        $query = Transaction::with(['punguan', 'person', 'verifier']);
        
        $punguanId = $request->getQueryParams()['punguan_id'] ?? null;
        if ($punguanId) {
            $query->where('punguan_id', $punguanId);
        }
        
        $tipe = $request->getQueryParams()['tipe'] ?? null;
        if ($tipe) {
            $query->where('tipe', $tipe);
        }
        
        $status = $request->getQueryParams()['status'] ?? null;
        if ($status) {
            $query->where('status', $status);
        }
        
        $page = max(1, (int)($request->getQueryParams()['page'] ?? 1));
        $limit = min(100, max(1, (int)($request->getQueryParams()['limit'] ?? 20)));
        $total = $query->count();
        $transactions = $query->orderBy('tanggal', 'desc')
            ->offset(($page - 1) * $limit)->limit($limit)->get();
        
        return $this->jsonResponse($response, [
            'success' => true,
            'data' => $transactions,
            'pagination' => [
                'page' => $page,
                'limit' => $limit,
                'total' => $total,
                'total_pages' => (int)ceil($total / $limit)
            ]
        ]);
    }
    
    public function createTransaction(Request $request, Response $response): Response
    {
        $body = $request->getParsedBody() ?? [];
        $currentUserId = $request->getAttribute('user_id');
        
        $transaction = Transaction::create([
            'punguan_id' => $body['punguan_id'],
            'tipe' => $body['tipe'] ?? 'masuk',
            'kategori' => $body['kategori'] ?? 'lainnya',
            'jumlah' => $body['jumlah'],
            'tanggal' => $body['tanggal'] ?? now(),
            'deskripsi' => $body['deskripsi'] ?? null,
            'person_id' => $body['person_id'] ?? null,
            'bukti_dokumen_id' => $body['bukti_dokumen_id'] ?? null,
            'status' => 'pending',
            'created_by' => $currentUserId
        ]);
        
        // Log to entity history with SoD context
        $this->auditService->log('created', $transaction, $currentUserId, null, $transaction->toArray(), 'Transaction created - requires verification by different user');
        
        return $this->jsonResponse($response, [
            'success' => true,
            'data' => $transaction,
            'message' => 'Transaction created successfully - requires verification'
        ], 201);
    }
    
    public function verifyTransaction(Request $request, Response $response, array $args): Response
    {
        $id = (int)$args['id'];
        $transaction = Transaction::find($id);
        
        if (!$transaction) {
            return $this->jsonResponse($response, [
                'success' => false,
                'error' => 'Transaction not found'
            ], 404);
        }
        
        $oldValues = $transaction->toArray();
        $transaction->status = 'verified';
        $transaction->verified_by = $request->getAttribute('user_id');
        $transaction->verified_at = now();
        $transaction->save();
        
        // Log to entity history
        $this->auditService->log('updated', $transaction, $request->getAttribute('user_id'), $oldValues, $transaction->toArray(), 'Transaction verified');
        
        return $this->jsonResponse($response, [
            'success' => true,
            'data' => $transaction,
            'message' => 'Transaction verified successfully'
        ]);
    }
    
    public function getBudgets(Request $request, Response $response): Response
    {
        $punguanId = $request->getQueryParams()['punguan_id'] ?? null;
        $tahun = $request->getQueryParams()['tahun'] ?? null;
        
        $query = Budget::with(['punguan', 'creator']);
        
        if ($punguanId) {
            $query->where('punguan_id', $punguanId);
        }
        
        if ($tahun) {
            $query->where('tahun', $tahun);
        }
        
        $budgets = $query->orderBy('tahun', 'desc')->get();
        
        return $this->jsonResponse($response, [
            'success' => true,
            'data' => $budgets
        ]);
    }
    
    public function createBudget(Request $request, Response $response): Response
    {
        $body = $request->getParsedBody() ?? [];
        
        $budget = Budget::create([
            'punguan_id' => $body['punguan_id'],
            'tahun' => $body['tahun'],
            'kategori' => $body['kategori'],
            'anggaran' => $body['anggaran'],
            'terpakai' => 0,
            'deskripsi' => $body['deskripsi'] ?? null,
            'created_by' => $request->getAttribute('user_id')
        ]);
        
        return $this->jsonResponse($response, [
            'success' => true,
            'data' => $budget,
            'message' => 'Budget created successfully'
        ], 201);
    }
    
    public function getIuran(Request $request, Response $response): Response
    {
        $punguanId = $request->getQueryParams()['punguan_id'] ?? null;
        $personId = $request->getQueryParams()['person_id'] ?? null;
        $status = $request->getQueryParams()['status'] ?? null;
        
        $query = Iuran::with(['punguan', 'person']);
        
        if ($punguanId) {
            $query->where('punguan_id', $punguanId);
        }
        
        if ($personId) {
            $query->where('person_id', $personId);
        }
        
        if ($status) {
            $query->where('status', $status);
        }
        
        $iuran = $query->orderBy('created_at', 'desc')->get();
        
        return $this->jsonResponse($response, [
            'success' => true,
            'data' => $iuran
        ]);
    }
    
    public function createIuran(Request $request, Response $response): Response
    {
        $body = $request->getParsedBody() ?? [];
        
        $iuran = Iuran::create([
            'punguan_id' => $body['punguan_id'],
            'person_id' => $body['person_id'] ?? null,
            'jenis_iuran' => $body['jenis_iuran'] ?? 'bulanan',
            'jumlah' => $body['jumlah'],
            'periode' => $body['periode'] ?? null,
            'status' => 'pending',
        ]);
        
        return $this->jsonResponse($response, [
            'success' => true,
            'data' => $iuran,
            'message' => 'Iuran created successfully'
        ], 201);
    }
    
    public function payIuran(Request $request, Response $response, array $args): Response
    {
        $id = (int)$args['id'];
        $body = $request->getParsedBody() ?? [];
        
        $iuran = Iuran::find($id);
        
        if (!$iuran) {
            return $this->jsonResponse($response, [
                'success' => false,
                'error' => 'Iuran not found'
            ], 404);
        }
        
        $iuran->status = 'verified';
        $iuran->verified_by = $request->getAttribute('user_id');
        $iuran->verified_at = now();
        $iuran->save();
        
        return $this->jsonResponse($response, [
            'success' => true,
            'data' => $iuran,
            'message' => 'Iuran paid successfully'
        ]);
    }
    
    public function getFinancialSummary(Request $request, Response $response): Response
    {
        $punguanId = $request->getQueryParams()['punguan_id'] ?? null;
        $tahun = $request->getQueryParams()['tahun'] ?? date('Y');
        
        $query = Transaction::query();
        if ($punguanId) {
            $query->where('punguan_id', $punguanId);
        }
        $query->whereYear('tanggal', $tahun);
        
        $pemasukan = (clone $query)->where('tipe', 'masuk')->where('status', 'verified')->sum('jumlah');
        $pengeluaran = (clone $query)->where('tipe', 'keluar')->where('status', 'verified')->sum('jumlah');
        
        $budgetQuery = Budget::query();
        if ($punguanId) {
            $budgetQuery->where('punguan_id', $punguanId);
        }
        $budgetQuery->where('tahun', $tahun);
        $totalAnggaran = $budgetQuery->sum('anggaran');
        $totalTerpakai = $budgetQuery->sum('terpakai');
        
        return $this->jsonResponse($response, [
            'success' => true,
            'data' => [
                'pemasukan' => $pemasukan,
                'pengeluaran' => $pengeluaran,
                'saldo' => $pemasukan - $pengeluaran,
                'total_anggaran' => $totalAnggaran,
                'total_terpakai' => $totalTerpakai,
                'sisa_anggaran' => $totalAnggaran - $totalTerpakai
            ]
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
