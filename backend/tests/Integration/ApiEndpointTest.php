<?php

namespace App\Tests\Integration;

use PHPUnit\Framework\TestCase;

class ApiEndpointTest extends TestCase
{
    private string $baseUrl = 'http://localhost:8000';

    public function testApiHealthCheck()
    {
        $response = $this->makeRequest('GET', $this->baseUrl . '/');
        
        $this->assertEquals(200, $this->getResponseCode($response));
        $this->assertStringContainsString('Tarombo Digital API', $response);
    }

    public function testGetPersonsEndpoint()
    {
        $response = $this->makeRequest('GET', $this->baseUrl . '/api/v1/persons');
        
        $this->assertEquals(200, $this->getResponseCode($response));
        $this->assertStringContainsString('data', $response);
    }

    public function testGetMargaEndpoint()
    {
        $response = $this->makeRequest('GET', $this->baseUrl . '/api/v1/marga');
        
        $this->assertEquals(200, $this->getResponseCode($response));
        $this->assertStringContainsString('data', $response);
    }

    public function testGetAssetsEndpoint()
    {
        $response = $this->makeRequest('GET', $this->baseUrl . '/api/v1/assets');
        
        $this->assertEquals(200, $this->getResponseCode($response));
        $this->assertStringContainsString('success', $response);
    }

    public function testGetEventsEndpoint()
    {
        $response = $this->makeRequest('GET', $this->baseUrl . '/api/v1/events');
        
        $this->assertEquals(200, $this->getResponseCode($response));
        $this->assertStringContainsString('success', $response);
    }

    public function testGetPunguanEndpoint()
    {
        $response = $this->makeRequest('GET', $this->baseUrl . '/api/v1/punguan');
        
        $this->assertEquals(200, $this->getResponseCode($response));
        $this->assertStringContainsString('success', $response);
    }

    public function testGetPartuturanCalculateEndpoint()
    {
        $response = $this->makeRequest('GET', $this->baseUrl . '/api/v1/partuturan/calculate?from=8&to=1');
        
        $this->assertEquals(200, $this->getResponseCode($response));
        $this->assertStringContainsString('relationship', $response);
    }

    public function testGetPartuturanCalculateMissingParams()
    {
        $response = $this->makeRequest('GET', $this->baseUrl . '/api/v1/partuturan/calculate');
        
        $this->assertEquals(400, $this->getResponseCode($response));
    }

    public function testPostAuthLoginEndpoint()
    {
        $data = json_encode([
            'email' => 'admin@tarombo.digital',
            'password' => 'password'
        ]);
        
        $response = $this->makeRequest('POST', $this->baseUrl . '/api/v1/auth/login', $data);
        
        $this->assertEquals(200, $this->getResponseCode($response));
        $this->assertStringContainsString('access_token', $response);
    }

    public function testPostAuthQuickLoginEndpoint()
    {
        $data = json_encode(['role' => 'admin']);
        
        $response = $this->makeRequest('POST', $this->baseUrl . '/api/v1/auth/quick-login', $data);
        
        $this->assertEquals(200, $this->getResponseCode($response));
        $this->assertStringContainsString('access_token', $response);
    }

    public function testGetPersonDetailEndpoint()
    {
        $response = $this->makeRequest('GET', $this->baseUrl . '/api/v1/persons/1');
        
        $this->assertEquals(200, $this->getResponseCode($response));
        $this->assertStringContainsString('John', $response);
    }

    public function testGetPersonNotFoundEndpoint()
    {
        $response = $this->makeRequest('GET', $this->baseUrl . '/api/v1/persons/99999');
        
        $this->assertEquals(404, $this->getResponseCode($response));
    }

    public function testPostPersonsUnauthorized()
    {
        $data = json_encode([
            'nama' => 'Test Person',
            'marga_id' => 1,
            'jenis_kelamin' => 'L'
        ]);
        
        $response = $this->makeRequest('POST', $this->baseUrl . '/api/v1/persons', $data);
        
        $this->assertEquals(401, $this->getResponseCode($response));
    }

    public function testGetPersonsWithSearch()
    {
        $response = $this->makeRequest('GET', $this->baseUrl . '/api/v1/persons?search=John');
        
        $this->assertEquals(200, $this->getResponseCode($response));
        $this->assertStringContainsString('John', $response);
    }

    private function makeRequest(string $method, string $url, ?string $data = null): string
    {
        $ch = curl_init();
        
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_CUSTOMREQUEST, $method);
        
        if ($data !== null) {
            curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
            curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: application/json']);
        }
        
        $response = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        
        curl_close($ch);
        
        // Store HTTP code for assertion
        $this->lastHttpCode = $httpCode;
        
        return $response ?: '';
    }

    private function getResponseCode(string $response): int
    {
        return $this->lastHttpCode ?? 0;
    }

    private ?int $lastHttpCode = null;
}
