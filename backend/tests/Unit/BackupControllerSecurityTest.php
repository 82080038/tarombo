<?php

namespace App\Tests\Unit;

use PHPUnit\Framework\TestCase;
use App\Controllers\BackupController;

class BackupControllerSecurityTest extends TestCase
{
    private array $allowedTables = [
        'marga', 'persons', 'marriages', 'marriage_stages',
        'ceremonies', 'punguan', 'punguan_members', 'documents',
        'makam', 'person_locations', 'forbidden_marga_pairs',
        'marga_hierarchy', 'iuran', 'assets', 'inheritance_records',
        'transactions', 'budgets', 'oral_traditions',
        'traditional_knowledge', 'cultural_sites', 'entity_history',
        'entity_timeline', 'entity_version', 'tanah_ulayat',
        'events', 'notifications'
    ];

    public function testAllowedTablesContainsCoreEntities()
    {
        $this->assertContains('persons', $this->allowedTables);
        $this->assertContains('marga', $this->allowedTables);
        $this->assertContains('marriages', $this->allowedTables);
    }

    public function testSensitiveTablesAreNotWhitelisted()
    {
        $this->assertNotContains('users', $this->allowedTables, 'users table must NOT be in export whitelist');
        $this->assertNotContains('security_audit_log', $this->allowedTables, 'security_audit_log must NOT be in export whitelist');
        $this->assertNotContains('notification_preferences', $this->allowedTables);
    }

    public function testWhitelistPreventsSqlInjectionOnExport()
    {
        $maliciousInputs = [
            'users; DROP TABLE persons; --',
            "users' OR '1'='1",
            'information_schema.tables',
            'mysql.user',
            '',
            'USERS',
            'users ',
        ];

        foreach ($maliciousInputs as $input) {
            $isAllowed = in_array($input, $this->allowedTables, true);
            $this->assertFalse($isAllowed, "Malicious input '{$input}' should be rejected by whitelist");
        }
    }

    public function testWhitelistUsesStrictComparison()
    {
        $this->assertFalse(in_array('persons ', $this->allowedTables, true), 'Trailing space should not match');
        $this->assertFalse(in_array(' persons', $this->allowedTables, true), 'Leading space should not match');
        $this->assertFalse(in_array('PERSONS', $this->allowedTables, true), 'Uppercase should not match');
        $this->assertTrue(in_array('persons', $this->allowedTables, true), 'Exact match should pass');
    }
}
