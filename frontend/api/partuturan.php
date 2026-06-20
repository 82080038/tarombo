<?php
/**
 * API: Partuturan & Kontribusi
 * Endpoints:
 *   GET  /api/partuturan?node1=X&node2=Y  → hitung sebutan kekerabatan
 *   GET  /api/partuturan/search?q=keyword  → cari node untuk dropdown
 *   POST /api/kontribusi                   → kirim usulan dari komunitas
 *   GET  /api/kontribusi                   → list usulan (admin only)
 *   POST /api/kontribusi/:id/approve       → setujui usulan (admin only)
 */

header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') exit(0);

$pdo = new PDO('mysql:unix_socket=/opt/lampp/var/mysql/mysql.sock;dbname=tarombo', 'root', 'root');
$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

$action = $_GET['action'] ?? '';
$method = $_SERVER['REQUEST_METHOD'];

try {
    if ($action === 'partuturan' && $method === 'GET') {
        // GET /api/partuturan?node1=X&node2=Y
        $node1 = (int)($_GET['node1'] ?? 0);
        $node2 = (int)($_GET['node2'] ?? 0);

        if (!$node1 || !$node2) {
            echo json_encode(['error' => 'Parameter node1 dan node2 wajib diisi']);
            exit;
        }

        require_once __DIR__ . '/../../backend/src/PartuturanCalculator.php';
        $calc = new PartuturanCalculator($pdo);
        $result = $calc->calculate($node1, $node2);
        $calc->cacheResult($node1, $node2, $result);

        // Get node info
        $stmt = $pdo->prepare("SELECT id, nama, jenis_kelamin, marga_turunan, generasi_ke FROM silsilah_mitolologis WHERE id IN (?, ?)");
        $stmt->execute([$node1, $node2]);
        $nodes = $stmt->fetchAll(PDO::FETCH_ASSOC);

        echo json_encode([
            'success' => true,
            'node1' => $nodes[0] ?? null,
            'node2' => $nodes[1] ?? null,
            'result' => $result,
        ], JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
        exit;
    }

    if ($action === 'search_nodes' && $method === 'GET') {
        // GET /api/partuturan?action=search_nodes&q=keyword
        $q = '%' . ($_GET['q'] ?? '') . '%';
        $stmt = $pdo->prepare("SELECT id, nama, jenis_kelamin, marga_turunan, generasi_ke, wilayah FROM silsilah_mitolologis WHERE nama LIKE ? OR marga_turunan LIKE ? ORDER BY generasi_ke, nama LIMIT 20");
        $stmt->execute([$q, $q]);
        echo json_encode(['success' => true, 'results' => $stmt->fetchAll(PDO::FETCH_ASSOC)], JSON_UNESCAPED_UNICODE);
        exit;
    }

    if ($action === 'kontribusi' && $method === 'POST') {
        // POST /api/kontribusi
        $input = json_decode(file_get_contents('php://input'), true);
        if (!$input) $input = $_POST;

        $jenis = $input['jenis'] ?? '';
        $validJenis = ['tambah_node', 'edit_node', 'tambah_marga', 'koreksi_silsilah', 'laporan_error'];
        if (!in_array($jenis, $validJenis)) {
            echo json_encode(['error' => 'Jenis tidak valid. Pilih: ' . implode(', ', $validJenis)]);
            exit;
        }

        $stmt = $pdo->prepare("INSERT INTO kontribusi (jenis, node_id, marga_id, data_usulan, catatan, nama_kontributor, email_kontributor) VALUES (?, ?, ?, ?, ?, ?, ?)");
        $stmt->execute([
            $jenis,
            $input['node_id'] ?? null,
            $input['marga_id'] ?? null,
            json_encode($input['data_usulan'] ?? $input, JSON_UNESCAPED_UNICODE),
            $input['catatan'] ?? null,
            $input['nama_kontributor'] ?? null,
            $input['email_kontributor'] ?? null,
        ]);

        $id = $pdo->lastInsertId();
        echo json_encode(['success' => true, 'id' => $id, 'message' => 'Kontribusi berhasil dikirim. Admin akan meninjau.'], JSON_UNESCAPED_UNICODE);
        exit;
    }

    if ($action === 'kontribusi_list' && $method === 'GET') {
        // GET /api/kontribusi?action=kontribusi_list
        $status = $_GET['status'] ?? 'pending';
        $stmt = $pdo->prepare("SELECT k.*, s.nama as node_nama, m.nama as marga_nama FROM kontribusi k LEFT JOIN silsilah_mitolologis s ON k.node_id = s.id LEFT JOIN marga m ON k.marga_id = m.id WHERE k.status = ? ORDER BY k.dibuat_pada DESC");
        $stmt->execute([$status]);
        echo json_encode(['success' => true, 'data' => $stmt->fetchAll(PDO::FETCH_ASSOC)], JSON_UNESCAPED_UNICODE);
        exit;
    }

    if ($action === 'kontribusi_approve' && $method === 'POST') {
        $input = json_decode(file_get_contents('php://input'), true);
        if (!$input) $input = $_POST;

        $id = (int)($input['id'] ?? 0);
        $adminNote = $input['catatan_admin'] ?? 'Disetujui';

        $stmt = $pdo->prepare("UPDATE kontribusi SET status = 'disetujui', catatan_admin = ?, diproses_pada = NOW() WHERE id = ?");
        $stmt->execute([$adminNote, $id]);

        echo json_encode(['success' => true, 'message' => 'Kontribusi disetujui'], JSON_UNESCAPED_UNICODE);
        exit;
    }

    if ($action === 'kontribusi_reject' && $method === 'POST') {
        $input = json_decode(file_get_contents('php://input'), true);
        if (!$input) $input = $_POST;

        $id = (int)($input['id'] ?? 0);
        $adminNote = $input['catatan_admin'] ?? 'Ditolak';

        $stmt = $pdo->prepare("UPDATE kontribusi SET status = 'ditolak', catatan_admin = ?, diproses_pada = NOW() WHERE id = ?");
        $stmt->execute([$adminNote, $id]);

        echo json_encode(['success' => true, 'message' => 'Kontribusi ditolak'], JSON_UNESCAPED_UNICODE);
        exit;
    }

    echo json_encode(['error' => 'Action tidak dikenal. Gunakan: partuturan, search_nodes, kontribusi, kontribusi_list, kontribusi_approve, kontribusi_reject'], JSON_UNESCAPED_UNICODE);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['error' => $e->getMessage()], JSON_UNESCAPED_UNICODE);
}
