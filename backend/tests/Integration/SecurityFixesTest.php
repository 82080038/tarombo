<?php

namespace App\Tests\Integration;

use PHPUnit\Framework\TestCase;

class SecurityFixesTest extends TestCase
{
    public function testCorsMiddlewareDoesNotCombineWildcardWithCredentials()
    {
        $reflection = new \ReflectionClass(\App\Middleware\CorsMiddleware::class);
        $source = file_get_contents($reflection->getFileName());

        $this->assertStringContainsString("CORS_ALLOW_ORIGIN", $source, 'CORS should use env variable');
        $this->assertStringContainsString('isWildcard', $source, 'CORS should check for wildcard before setting credentials');
        $this->assertStringNotContainsString(
            "withHeader('Access-Control-Allow-Credentials', 'true')\n    }",
            $source
        );
    }

    public function testQuickLoginHasIpWhitelist()
    {
        $reflection = new \ReflectionClass(\App\Controllers\AuthController::class);
        $source = file_get_contents($reflection->getFileName());

        $this->assertStringContainsString('allowedIps', $source, 'quickLogin must check client IP');
        $this->assertStringContainsString('127.0.0.1', $source, 'quickLogin must restrict to localhost');
        $this->assertStringContainsString('::1', $source, 'quickLogin must allow IPv6 localhost');
    }

    public function testJwtSecretHasNoWeakFallback()
    {
        $reflection = new \ReflectionClass(\App\Controllers\AuthController::class);
        $source = file_get_contents($reflection->getFileName());

        $this->assertStringNotContainsString(
            "tarombo-secret-key-2024",
            $source,
            'AuthController must not have weak JWT secret fallback'
        );
        $this->assertStringContainsString(
            'RuntimeException',
            $source,
            'AuthController should throw if JWT_SECRET is missing'
        );
    }

    public function testAuthMiddlewareHasNoWeakFallback()
    {
        $reflection = new \ReflectionClass(\App\Middleware\AuthMiddleware::class);
        $source = file_get_contents($reflection->getFileName());

        $this->assertStringNotContainsString(
            'your-secret-key-change-in-production',
            $source,
            'AuthMiddleware must not have weak JWT secret fallback'
        );
    }

    public function testErrorMiddlewareIsEnvironmentAware()
    {
        $source = file_get_contents(__DIR__ . '/../../public/index.php');

        $this->assertStringContainsString('isProduction', $source, 'Error middleware should check APP_ENV');
        $this->assertStringContainsString('APP_ENV', $source);
        $this->assertStringContainsString('!$isProduction', $source, 'Error details should be disabled in production');
    }

    public function testBackupControllerHasTableWhitelist()
    {
        $reflection = new \ReflectionClass(\App\Controllers\BackupController::class);
        $source = file_get_contents($reflection->getFileName());

        $this->assertStringContainsString('ALLOWED_TABLES', $source, 'BackupController must have table whitelist');
        $this->assertStringContainsString('in_array($entityType, self::ALLOWED_TABLES)', $source);
        $this->assertStringContainsString('in_array($table, self::ALLOWED_TABLES)', $source);
    }

    public function testMarriageModelUsesDatabaseForForbiddenPairs()
    {
        $reflection = new \ReflectionClass(\App\Models\Marriage::class);
        $source = file_get_contents($reflection->getFileName());

        $this->assertStringContainsString('ForbiddenMargaPair', $source, 'Marriage model should use ForbiddenMargaPair model');
        $this->assertStringNotContainsString("'Marbun', 'Sihotang'", $source, 'Marriage model should not have hardcoded forbidden pairs');
    }

    public function testPartuturanServiceHasDepthLimit()
    {
        $reflection = new \ReflectionClass(\App\Services\PartuturanService::class);
        $source = file_get_contents($reflection->getFileName());

        $this->assertStringContainsString('maxDepth', $source, 'PartuturanService must have BFS depth limit');
        $this->assertStringContainsString('$depth >= $maxDepth', $source);
    }
}
