<?php

namespace App\Tests\Integration;

use PHPUnit\Framework\TestCase;

class ReportExportSimulationTest extends TestCase
{
    private string $baseUrl = 'http://localhost:8000';
    private ?string $adminToken = null;
    private ?string $userToken = null;

    protected function setUp(): void
    {
        // Login as admin
        $data = json_encode(['role' => 'admin']);
        $response = $this->makeRequest('POST', $this->baseUrl . '/api/v1/auth/quick-login', $data);
        if ($this->getResponseCode($response) === 200) {
            $json = json_decode($response, true);
            $this->adminToken = $json['access_token'] ?? null;
        }
        
        // Login as user
        $data = json_encode(['role' => 'user']);
        $response = $this->makeRequest('POST', $this->baseUrl . '/api/v1/auth/quick-login', $data);
        if ($this->getResponseCode($response) === 200) {
            $json = json_decode($response, true);
            $this->userToken = $json['access_token'] ?? null;
        }
    }

    public function testExportPersonsExcelAsAdmin()
    {
        if (!$this->adminToken) {
            $this->markTestSkipped('Admin token not available');
        }

        echo "\n=== EXPORT PERSONS EXCEL SIMULATION ===\n";
        
        $response = $this->makeRequest('GET', $this->baseUrl . '/api/v1/reports/persons/excel', null, $this->adminToken);
        $code = $this->getResponseCode($response);
        
        echo "Response Code: $code\n";
        echo "Content-Type: " . $this->getHeaderValue($response, 'Content-Type') . "\n";
        echo "Content-Disposition: " . $this->getHeaderValue($response, 'Content-Disposition') . "\n";
        echo "Response Size: " . strlen($response) . " bytes\n";
        
        $this->assertEquals(200, $code);
        $this->assertStringContainsString('application/vnd.openxmlformats', $this->getHeaderValue($response, 'Content-Type'));
        $this->assertStringContainsString('persons_', $this->getHeaderValue($response, 'Content-Disposition'));
        
        echo "✅ Export persons Excel successful\n";
        echo "=== EXPORT PERSONS EXCEL SIMULATION COMPLETE ===\n\n";
    }

    public function testExportPersonsCsvAsAdmin()
    {
        if (!$this->adminToken) {
            $this->markTestSkipped('Admin token not available');
        }

        echo "\n=== EXPORT PERSONS CSV SIMULATION ===\n";
        
        $response = $this->makeRequest('GET', $this->baseUrl . '/api/v1/reports/persons/csv', null, $this->adminToken);
        $code = $this->getResponseCode($response);
        
        echo "Response Code: $code\n";
        echo "Content-Type: " . $this->getHeaderValue($response, 'Content-Type') . "\n";
        echo "Response Size: " . strlen($response) . " bytes\n";
        
        $this->assertEquals(200, $code);
        $this->assertStringContainsString('text/csv', $this->getHeaderValue($response, 'Content-Type'));
        
        echo "✅ Export persons CSV successful\n";
        echo "=== EXPORT PERSONS CSV SIMULATION COMPLETE ===\n\n";
    }

    public function testExportFamilyTreePdfAsAdmin()
    {
        if (!$this->adminToken) {
            $this->markTestSkipped('Admin token not available');
        }

        echo "\n=== EXPORT FAMILY TREE PDF SIMULATION ===\n";
        
        $response = $this->makeRequest('GET', $this->baseUrl . '/api/v1/reports/family-tree/pdf', null, $this->adminToken);
        $code = $this->getResponseCode($response);
        
        echo "Response Code: $code\n";
        echo "Content-Type: " . $this->getHeaderValue($response, 'Content-Type') . "\n";
        echo "Response Size: " . strlen($response) . " bytes\n";
        
        $this->assertEquals(200, $code);
        $this->assertStringContainsString('application/pdf', $this->getHeaderValue($response, 'Content-Type'));
        
        echo "✅ Export family tree PDF successful\n";
        echo "=== EXPORT FAMILY TREE PDF SIMULATION COMPLETE ===\n\n";
    }

    public function testExportMarriagesExcelAsAdmin()
    {
        if (!$this->adminToken) {
            $this->markTestSkipped('Admin token not available');
        }

        echo "\n=== EXPORT MARRIAGES EXCEL SIMULATION ===\n";
        
        $response = $this->makeRequest('GET', $this->baseUrl . '/api/v1/reports/marriages/excel', null, $this->adminToken);
        $code = $this->getResponseCode($response);
        
        echo "Response Code: $code\n";
        echo "Content-Type: " . $this->getHeaderValue($response, 'Content-Type') . "\n";
        echo "Response Size: " . strlen($response) . " bytes\n";
        
        $this->assertEquals(200, $code);
        $this->assertStringContainsString('application/vnd.openxmlformats', $this->getHeaderValue($response, 'Content-Type'));
        
        echo "✅ Export marriages Excel successful\n";
        echo "=== EXPORT MARRIAGES EXCEL SIMULATION COMPLETE ===\n\n";
    }

    public function testExportStatisticsPdfAsAdmin()
    {
        if (!$this->adminToken) {
            $this->markTestSkipped('Admin token not available');
        }

        echo "\n=== EXPORT STATISTICS PDF SIMULATION ===\n";
        
        $response = $this->makeRequest('GET', $this->baseUrl . '/api/v1/reports/statistics/pdf', null, $this->adminToken);
        $code = $this->getResponseCode($response);
        
        echo "Response Code: $code\n";
        echo "Content-Type: " . $this->getHeaderValue($response, 'Content-Type') . "\n";
        echo "Response Size: " . strlen($response) . " bytes\n";
        
        $this->assertEquals(200, $code);
        $this->assertStringContainsString('application/pdf', $this->getHeaderValue($response, 'Content-Type'));
        
        echo "✅ Export statistics PDF successful\n";
        echo "=== EXPORT STATISTICS PDF SIMULATION COMPLETE ===\n\n";
    }

    public function testExportWithoutAuthentication()
    {
        echo "\n=== EXPORT WITHOUT AUTHENTICATION SIMULATION ===\n";
        
        $response = $this->makeRequest('GET', $this->baseUrl . '/api/v1/reports/persons/excel');
        $code = $this->getResponseCode($response);
        
        echo "Response Code: $code\n";
        
        // Should return 401 Unauthorized
        $this->assertEquals(401, $code);
        
        echo "✅ Export without authentication properly blocked\n";
        echo "=== EXPORT WITHOUT AUTHENTICATION SIMULATION COMPLETE ===\n\n";
    }

    public function testExportAsRegularUser()
    {
        if (!$this->userToken) {
            $this->markTestSkipped('User token not available');
        }

        echo "\n=== EXPORT AS REGULAR USER SIMULATION ===\n";
        
        $response = $this->makeRequest('GET', $this->baseUrl . '/api/v1/reports/persons/excel', null, $this->userToken);
        $code = $this->getResponseCode($response);
        
        echo "Response Code: $code\n";
        
        // Regular user should be able to export (has AuthMiddleware only)
        $this->assertEquals(200, $code);
        
        echo "✅ Export as regular user successful\n";
        echo "=== EXPORT AS REGULAR USER SIMULATION COMPLETE ===\n\n";
    }

    private function makeRequest(string $method, string $url, ?string $data = null, ?string $token = null): string
    {
        $ch = curl_init();
        
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_CUSTOMREQUEST, $method);
        curl_setopt($ch, CURLOPT_HEADER, true);
        
        if ($token !== null) {
            curl_setopt($ch, CURLOPT_HTTPHEADER, [
                'Authorization: Bearer ' . $token,
                'Content-Type: application/json'
            ]);
        } elseif ($data !== null) {
            curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: application/json']);
        }
        
        if ($data !== null) {
            curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
        }
        
        $response = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        
        curl_close($ch);
        
        $this->lastHttpCode = $httpCode;
        $this->lastResponse = $response;
        
        return $response ?: '';
    }

    private function getResponseCode(string $response): int
    {
        return $this->lastHttpCode ?? 0;
    }

    private function getHeaderValue(string $response, string $header): string
    {
        $headers = [];
        $headerText = substr($this->lastResponse, 0, strpos($this->lastResponse, "\r\n\r\n"));
        
        foreach (explode("\r\n", $headerText) as $line) {
            if (strpos($line, ':') !== false) {
                list($key, $value) = explode(':', $line, 2);
                $headers[trim($key)] = trim($value);
            }
        }
        
        return $headers[$header] ?? '';
    }

    private ?int $lastHttpCode = null;
    private ?string $lastResponse = null;
}
