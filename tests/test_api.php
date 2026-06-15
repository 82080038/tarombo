<?php
/**
 * API Testing Script
 * Test API endpoints directly using PHP
 */

$apiBaseUrl = 'http://localhost/tarombo/api/v1';

function testEndpoint($url, $method = 'GET', $data = null) {
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, $method);
    
    if ($data) {
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));
        curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: application/json']);
    }
    
    $response = curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);
    
    return [
        'status_code' => $httpCode,
        'response' => json_decode($response, true),
        'raw' => $response
    ];
}

echo "=== TAROMBO DIGITAL API TEST ===\n\n";

// Test 1: Health Check
echo "Test 1: Health Check\n";
$result = testEndpoint($apiBaseUrl . '/');
echo "Status Code: " . $result['status_code'] . "\n";
echo "Response: " . json_encode($result['response'], JSON_PRETTY_PRINT) . "\n\n";

// Test 2: Get Persons
echo "Test 2: Get Persons\n";
$result = testEndpoint($apiBaseUrl . '/persons');
echo "Status Code: " . $result['status_code'] . "\n";
echo "Response: " . json_encode($result['response'], JSON_PRETTY_PRINT) . "\n\n";

// Test 3: Get Marga
echo "Test 3: Get Marga\n";
$result = testEndpoint($apiBaseUrl . '/marga');
echo "Status Code: " . $result['status_code'] . "\n";
echo "Response: " . json_encode($result['response'], JSON_PRETTY_PRINT) . "\n\n";

// Test 4: Get Assets
echo "Test 4: Get Assets\n";
$result = testEndpoint($apiBaseUrl . '/assets');
echo "Status Code: " . $result['status_code'] . "\n";
echo "Response: " . json_encode($result['response'], JSON_PRETTY_PRINT) . "\n\n";

// Test 5: Get Finance Transactions
echo "Test 5: Get Finance Transactions\n";
$result = testEndpoint($apiBaseUrl . '/finance/transactions');
echo "Status Code: " . $result['status_code'] . "\n";
echo "Response: " . json_encode($result['response'], JSON_PRETTY_PRINT) . "\n\n";

// Test 6: Get Oral Traditions
echo "Test 6: Get Oral Traditions\n";
$result = testEndpoint($apiBaseUrl . '/history/oral-traditions');
echo "Status Code: " . $result['status_code'] . "\n";
echo "Response: " . json_encode($result['response'], JSON_PRETTY_PRINT) . "\n\n";

// Test 7: Get Cultural Sites
echo "Test 7: Get Cultural Sites\n";
$result = testEndpoint($apiBaseUrl . '/history/cultural-sites');
echo "Status Code: " . $result['status_code'] . "\n";
echo "Response: " . json_encode($result['response'], JSON_PRETTY_PRINT) . "\n\n";

echo "=== TEST COMPLETE ===\n";
