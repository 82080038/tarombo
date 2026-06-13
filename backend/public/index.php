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
use App\Middleware\AuthMiddleware;
use App\Middleware\CorsMiddleware;

require __DIR__ . '/../vendor/autoload.php';

// Load environment variables
$dotenv = Dotenv\Dotenv::createImmutable(__DIR__ . '/../');
$dotenv->safeLoad();

// Create Slim app
AppFactory::setContainer(new DI\Container());
$app = AppFactory::create();

// Add middleware
$app->add(new CorsMiddleware());
$app->addBodyParsingMiddleware();
$app->addRoutingMiddleware();
$app->addErrorMiddleware(true, true, true);

// Database initialization
require __DIR__ . '/../config/database.php';

// Health check endpoint
$app->get('/', function ($request, $response) {
    $response->getBody()->write(json_encode([
        'status' => 'ok',
        'message' => 'Tarombo Digital API',
        'version' => '1.0.0'
    ]));
    return $response->withHeader('Content-Type', 'application/json');
});

// API Routes - Auth
$app->group('/api/v1/auth', function ($group) {
    $group->post('/login', [AuthController::class, 'login']);
    $group->post('/register', [AuthController::class, 'register']);
    $group->post('/logout', [AuthController::class, 'logout'])->add(AuthMiddleware::class);
    $group->get('/me', [AuthController::class, 'me'])->add(AuthMiddleware::class);
    $group->post('/quick-login', [AuthController::class, 'quickLogin']);
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
    $group->get('/statistics', [AdminController::class, 'statistics'])->add(AuthMiddleware::class);
    $group->get('/users', [AdminController::class, 'users'])->add(AuthMiddleware::class);
    $group->put('/users/{id}/role', [AdminController::class, 'updateUserRole'])->add(AuthMiddleware::class);
});

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

// Run app
$app->run();
