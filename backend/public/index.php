<?php
/**
 * Tarombo Digital Backend API
 * Entry Point
 */

use Slim\Factory\AppFactory;
use App\Controllers\PersonController;
use App\Controllers\MargaController;
use App\Controllers\AuthController;
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

// Partuturan calculation endpoint
$app->get('/api/v1/partuturan/calculate', [PersonController::class, 'calculatePartuturan']);

// Run app
$app->run();
