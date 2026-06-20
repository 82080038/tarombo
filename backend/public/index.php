<?php
/**
 * Tarombo Digital Backend API
 * Entry Point
 */

use Slim\Factory\AppFactory;
use App\Controllers\PersonController;
use App\Controllers\MargaController;
use App\Controllers\AuthController;
use App\Controllers\MarriageController;
use App\Controllers\CeremonyController;
use App\Controllers\PunguanController;
use App\Controllers\DocumentController;
use App\Controllers\MakamController;
use App\Controllers\GeoController;
use App\Controllers\AdminController;
use App\Controllers\AssetController;
use App\Controllers\FinanceController;
use App\Controllers\EventController;
use App\Controllers\HeritageController;
use App\Controllers\CommunicationController;
use App\Controllers\LocationController;
use App\Controllers\HistoryController;
use App\Controllers\BackupController;
use App\Middleware\AuthMiddleware;
use App\Middleware\AdminMiddleware;
use App\Middleware\CorsMiddleware;
use App\Middleware\AuditMiddleware;
use App\Middleware\RateLimitMiddleware;

require __DIR__ . '/../vendor/autoload.php';

// Load environment variables
$dotenv = Dotenv\Dotenv::createImmutable(__DIR__ . '/../');
$dotenv->safeLoad();

// Create Slim app
AppFactory::setContainer(new DI\Container());
$app = AppFactory::create();

// Add middleware
$app->add(new CorsMiddleware());
// Disable AuditMiddleware temporarily to fix JSON duplication
// $app->add(new AuditMiddleware());
$app->addBodyParsingMiddleware();
$app->addRoutingMiddleware();
$isProduction = ($_ENV['APP_ENV'] ?? 'production') === 'production';
$app->addErrorMiddleware(!$isProduction, !$isProduction, false);

// Database initialization
require __DIR__ . '/../config/database.php';

// Health check endpoint - moved to /health to avoid conflicts
$app->get('/health', function ($request, $response) {
    $response->getBody()->write(json_encode([
        'status' => 'ok',
        'message' => 'Tarombo Digital API',
        'version' => '1.0.0'
    ]));
    return $response->withHeader('Content-Type', 'application/json');
});

// API Routes - Auth
$app->group('/api/v1/auth', function ($group) {
    $group->post('/login', [AuthController::class, 'login'])->add(new RateLimitMiddleware());
    $group->post('/register', [AuthController::class, 'register'])->add(new RateLimitMiddleware());
    $group->post('/logout', [AuthController::class, 'logout'])->add(AuthMiddleware::class);
    $group->get('/me', [AuthController::class, 'me'])->add(AuthMiddleware::class);
    $group->post('/quick-login', [AuthController::class, 'quickLogin']);
    $group->post('/forgot-password', [AuthController::class, 'forgotPassword'])->add(new RateLimitMiddleware());
    $group->post('/reset-password', [AuthController::class, 'resetPassword'])->add(new RateLimitMiddleware());
    $group->post('/verify-email', [AuthController::class, 'verifyEmail']);
});

// API Routes - Persons
$app->group('/api/v1/persons', function ($group) {
    $group->get('', [PersonController::class, 'index']);
    $group->get('/{id}', [PersonController::class, 'show']);
    $group->post('', [PersonController::class, 'store'])->add(AuthMiddleware::class);
    $group->put('/{id}', [PersonController::class, 'update'])->add(AuthMiddleware::class);
    $group->delete('/{id}', [PersonController::class, 'destroy'])->add(AuthMiddleware::class);
});

// API Routes - Marga
$app->group('/api/v1/marga', function ($group) {
    $group->get('', [MargaController::class, 'index']);
    $group->get('/{id}', [MargaController::class, 'show']);
});

// API Routes - Marriages
$app->group('/api/v1/marriages', function ($group) {
    $group->get('', [MarriageController::class, 'index']);
    $group->get('/{id}', [MarriageController::class, 'show']);
    $group->post('', [MarriageController::class, 'store'])->add(AuthMiddleware::class);
    $group->put('/{id}/stages/{stage_id}', [MarriageController::class, 'updateStage'])->add(AuthMiddleware::class);
    $group->delete('/{id}', [MarriageController::class, 'destroy'])->add(AuthMiddleware::class);
});

// Check if two margas can marry
$app->get('/api/v1/margas/{id}/can-marry/{target_id}', [MarriageController::class, 'canMarry']);

// Partuturan calculation endpoint
$app->get('/api/v1/partuturan/calculate', [PersonController::class, 'calculatePartuturan']);

// Admin routes
$app->group('/api/v1/admin', function ($group) {
    $group->get('/statistics', [AdminController::class, 'statistics']);
    $group->get('/users', [AdminController::class, 'users']);
    $group->put('/users/{id}/role', [AdminController::class, 'updateUserRole']);
})->add(new AdminMiddleware())->add(new AuthMiddleware());

// Ceremony routes
$app->group('/api/v1/ceremonies', function ($group) {
    $group->get('', [CeremonyController::class, 'index']);
    $group->post('', [CeremonyController::class, 'store'])->add(AuthMiddleware::class);
    $group->get('/{id}', [CeremonyController::class, 'show']);
    $group->put('/{id}', [CeremonyController::class, 'update'])->add(AuthMiddleware::class);
});

// Punguan routes
$app->group('/api/v1/punguan', function ($group) {
    $group->get('', [PunguanController::class, 'index']);
    $group->get('/{id}', [PunguanController::class, 'show']);
    $group->get('/{id}/members', [PunguanController::class, 'members']);
    $group->post('', [PunguanController::class, 'store'])->add(AuthMiddleware::class);
});

// Document routes
$app->group('/api/v1/documents', function ($group) {
    $group->get('', [DocumentController::class, 'index']);
    $group->get('/{id}', [DocumentController::class, 'show']);
    $group->post('', [DocumentController::class, 'store'])->add(AuthMiddleware::class);
});

// Makam routes
$app->group('/api/v1/makam', function ($group) {
    $group->get('', [MakamController::class, 'index']);
    $group->get('/{id}', [MakamController::class, 'show']);
    $group->post('', [MakamController::class, 'store'])->add(AuthMiddleware::class);
});

// Geo / Map routes
$app->group('/api/v1/geo', function ($group) {
    $group->get('/persons', [GeoController::class, 'personLocations']);
    $group->get('/makam', [GeoController::class, 'makamLocations']);
    $group->get('/statistics', [GeoController::class, 'statistics']);
});

// Asset routes (Harta Warisan)
$app->group('/api/v1/assets', function ($group) {
    $group->get('', [AssetController::class, 'index']);
    $group->get('/{id}', [AssetController::class, 'show']);
    $group->post('', [AssetController::class, 'store'])->add(AuthMiddleware::class);
    $group->put('/{id}', [AssetController::class, 'update'])->add(AuthMiddleware::class);
    $group->delete('/{id}', [AssetController::class, 'destroy'])->add(AuthMiddleware::class);
    $group->post('/{id}/transfer', [AssetController::class, 'transferOwnership'])->add(AuthMiddleware::class);
    $group->get('/{id}/inheritance', [AssetController::class, 'getInheritanceHistory']);
});

// Finance routes (Keuangan Punguan)
$app->group('/api/v1/finance', function ($group) {
    $group->get('/transactions', [FinanceController::class, 'getTransactions']);
    $group->post('/transactions', [FinanceController::class, 'createTransaction'])->add(AuthMiddleware::class);
    $group->put('/transactions/{id}/verify', [FinanceController::class, 'verifyTransaction'])->add(AuthMiddleware::class);
    $group->get('/budgets', [FinanceController::class, 'getBudgets']);
    $group->post('/budgets', [FinanceController::class, 'createBudget'])->add(AuthMiddleware::class);
    $group->get('/iuran', [FinanceController::class, 'getIuran']);
    $group->post('/iuran', [FinanceController::class, 'createIuran'])->add(AuthMiddleware::class);
    $group->put('/iuran/{id}/pay', [FinanceController::class, 'payIuran'])->add(AuthMiddleware::class);
    $group->get('/summary', [FinanceController::class, 'getFinancialSummary']);
});

// Event routes (Acara & Kalender)
$app->group('/api/v1/events', function ($group) {
    $group->get('', [EventController::class, 'index']);
    $group->get('/{id}', [EventController::class, 'show']);
    $group->post('', [EventController::class, 'store'])->add(AuthMiddleware::class);
    $group->put('/{id}', [EventController::class, 'update'])->add(AuthMiddleware::class);
    $group->delete('/{id}', [EventController::class, 'destroy'])->add(AuthMiddleware::class);
    $group->post('/{id}/attendees', [EventController::class, 'addAttendee'])->add(AuthMiddleware::class);
    $group->put('/{id}/attendees/{attendee_id}', [EventController::class, 'updateAttendee'])->add(AuthMiddleware::class);
});

// Heritage routes (Sejarah & Tradisi)
$app->group('/api/v1/heritage', function ($group) {
    $group->get('/traditions', [HeritageController::class, 'getTraditions']);
    $group->post('/traditions', [HeritageController::class, 'createTradition'])->add(AuthMiddleware::class);
    $group->get('/stories', [HeritageController::class, 'getStories']);
    $group->post('/stories', [HeritageController::class, 'createStory'])->add(AuthMiddleware::class);
    $group->put('/stories/{id}/publish', [HeritageController::class, 'publishStory'])->add(AuthMiddleware::class);
});

// Communication routes (Komunikasi)
$app->group('/api/v1/communication', function ($group) {
    $group->get('/announcements', [CommunicationController::class, 'getAnnouncements']);
    $group->post('/announcements', [CommunicationController::class, 'createAnnouncement'])->add(AuthMiddleware::class);
    $group->put('/announcements/{id}/publish', [CommunicationController::class, 'publishAnnouncement'])->add(AuthMiddleware::class);
    $group->get('/messages', [CommunicationController::class, 'getMessages'])->add(AuthMiddleware::class);
    $group->post('/messages', [CommunicationController::class, 'createMessage'])->add(AuthMiddleware::class);
    $group->get('/notifications', [CommunicationController::class, 'getNotifications'])->add(AuthMiddleware::class);
    $group->put('/notifications/{id}/read', [CommunicationController::class, 'markNotificationRead'])->add(AuthMiddleware::class);
    $group->put('/notifications/mark-all-read', [CommunicationController::class, 'markAllNotificationsRead'])->add(AuthMiddleware::class);
    $group->get('/notifications/unread-count', [CommunicationController::class, 'getUnreadCount'])->add(AuthMiddleware::class);
});

// Location routes (Perluasan Tempat)
$app->group('/api/v1/locations', function ($group) {
    $group->get('/rumah', [LocationController::class, 'index']);
    $group->get('/rumah/{id}', [LocationController::class, 'show']);
    $group->post('/rumah', [LocationController::class, 'store'])->add(AuthMiddleware::class);
    $group->put('/rumah/{id}', [LocationController::class, 'update'])->add(AuthMiddleware::class);
    $group->delete('/rumah/{id}', [LocationController::class, 'destroy'])->add(AuthMiddleware::class);
});

// History & Cultural Preservation routes
$app->group('/api/v1/history', function ($group) {
    $group->get('/{type}/{id}', [HistoryController::class, 'getEntityHistory']);
    $group->get('/timeline/{type}/{id}', [HistoryController::class, 'getEntityTimeline']);
    $group->get('/oral-traditions', [HistoryController::class, 'getOralTraditions']);
    $group->post('/oral-traditions', [HistoryController::class, 'createOralTradition'])->add(AuthMiddleware::class);
    $group->get('/traditional-knowledge', [HistoryController::class, 'getTraditionalKnowledge']);
    $group->post('/traditional-knowledge', [HistoryController::class, 'createTraditionalKnowledge'])->add(AuthMiddleware::class);
    $group->get('/cultural-sites', [HistoryController::class, 'getCulturalSites']);
    $group->post('/cultural-sites', [HistoryController::class, 'createCulturalSite'])->add(AuthMiddleware::class);
});

// Backup routes (Export/Import)
$app->group('/api/v1/backup', function ($group) {
    $group->get('/export', [BackupController::class, 'export'])->add(AuthMiddleware::class);
    $group->get('/export/{type}', [BackupController::class, 'exportEntity'])->add(AuthMiddleware::class);
    $group->post('/import', [BackupController::class, 'import'])->add(AuthMiddleware::class);
    $group->get('/history', [BackupController::class, 'getBackupHistory'])->add(AuthMiddleware::class);
});

// Report routes (Export/Import Reports)
$app->group('/api/v1/reports', function ($group) {
    $group->get('/persons/excel', [ReportController::class, 'exportPersonsExcel'])->add(AuthMiddleware::class);
    $group->get('/persons/csv', [ReportController::class, 'exportPersonsCsv'])->add(AuthMiddleware::class);
    $group->get('/family-tree/pdf', [ReportController::class, 'exportFamilyTreePdf'])->add(AuthMiddleware::class);
    $group->get('/marriages/excel', [ReportController::class, 'exportMarriagesExcel'])->add(AuthMiddleware::class);
    $group->get('/statistics/pdf', [ReportController::class, 'exportStatisticsPdf'])->add(AuthMiddleware::class);
});

// GEDCOM routes (Genealogy data exchange)
$app->group('/api/v1/gedcom', function ($group) {
    $group->get('/export', function ($request, $response) {
        $service = new \App\Services\GedcomService();
        $gedcom = $service->export();
        $response->getBody()->write($gedcom);
        return $response
            ->withHeader('Content-Type', 'text/plain')
            ->withHeader('Content-Disposition', 'attachment; filename="tarombo_export.ged"');
    })->add(AuthMiddleware::class);
    $group->post('/import', function ($request, $response) {
        $body = $request->getParsedBody() ?? [];
        $content = $body['content'] ?? '';
        if (empty($content)) {
            $files = $request->getUploadedFiles();
            if (isset($files['file'])) {
                $content = $files['file']->getStream()->getContents();
            }
        }
        if (empty($content)) {
            $response->getBody()->write(json_encode([
                'success' => false,
                'error' => ['code' => 'EMPTY_CONTENT', 'message' => 'GEDCOM content or file required']
            ]));
            return $response->withHeader('Content-Type', 'application/json')->withStatus(400);
        }
        $service = new \App\Services\GedcomService();
        $stats = $service->import($content);
        $response->getBody()->write(json_encode(['success' => true, 'data' => $stats]));
        return $response->withHeader('Content-Type', 'application/json');
    })->add(AuthMiddleware::class);
});

// Run app
$app->run();
