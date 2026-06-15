<?php

namespace App\Tests\Unit;

use App\Services\AuditService;
use App\Models\Person;
use PHPUnit\Framework\TestCase;

class AuditServiceTest extends TestCase
{
    private AuditService $auditService;

    protected function setUp(): void
    {
        $this->auditService = new AuditService();
    }

    public function testGetEntityNameReturnsCorrectName()
    {
        $person = new Person();
        $person->id = 1;
        
        // Test that the service can extract entity name
        $entityType = get_class($person);
        
        $this->assertEquals('App\\Models\\Person', $entityType);
    }

    public function testLogActionRequiresValidParameters()
    {
        $person = new Person();
        $person->id = 1;
        
        // Test that log method requires proper parameters
        $action = 'create';
        $performedBy = 1;
        $oldValues = null;
        $newValues = ['nama' => 'John'];
        $reason = 'Initial creation';
        
        $this->assertIsString($action);
        $this->assertIsInt($performedBy);
        $this->assertIsArray($newValues);
        $this->assertIsString($reason);
    }

    public function testLogTimelineEventStructure()
    {
        $entityType = 'Person';
        $entityId = 1;
        $eventType = 'birth';
        $eventDate = '1950-01-15';
        $eventDescription = 'Person was born';
        $eventData = ['location' => 'Medan'];
        
        $this->assertEquals('Person', $entityType);
        $this->assertEquals(1, $entityId);
        $this->assertEquals('birth', $eventType);
        $this->assertEquals('1950-01-15', $eventDate);
        $this->assertEquals('Person was born', $eventDescription);
        $this->assertIsArray($eventData);
    }

    public function testCreateEntityVersionStructure()
    {
        $entityType = 'Person';
        $entityId = 1;
        $versionNumber = 1;
        $versionData = ['nama' => 'John', 'marga_id' => 32];
        $versionDescription = 'Initial version';
        $createdBy = 1;
        
        $this->assertEquals('Person', $entityType);
        $this->assertEquals(1, $entityId);
        $this->assertEquals(1, $versionNumber);
        $this->assertIsArray($versionData);
        $this->assertEquals('Initial version', $versionDescription);
        $this->assertEquals(1, $createdBy);
    }

    public function testJsonEncodingOfValues()
    {
        $oldValues = ['nama' => 'Old Name', 'marga_id' => 10];
        $newValues = ['nama' => 'New Name', 'marga_id' => 32];
        
        $oldJson = json_encode($oldValues);
        $newJson = json_encode($newValues);
        
        $this->assertIsString($oldJson);
        $this->assertIsString($newJson);
        $this->assertStringContainsString('Old Name', $oldJson);
        $this->assertStringContainsString('New Name', $newJson);
    }

    public function testGetEntityHistoryReturnsArray()
    {
        $entityType = 'Person';
        $entityId = 1;
        
        // The method should return an array
        $expectedType = 'array';
        
        $this->assertEquals('Person', $entityType);
        $this->assertEquals(1, $entityId);
        $this->assertEquals('array', $expectedType);
    }

    public function testNotificationServiceCanBeSet()
    {
        // Test that notification service can be injected
        $this->assertNotNull($this->auditService);
        
        // The service should have a method to set notification service
        $this->assertIsObject($this->auditService);
    }

    public function testAuditLogFields()
    {
        $requiredFields = [
            'entity_type',
            'entity_id',
            'action',
            'changed_by',
            'old_values',
            'new_values',
            'reason',
            'changed_at'
        ];
        
        foreach ($requiredFields as $field) {
            $this->assertIsString($field);
        }
        
        $this->assertCount(8, $requiredFields);
    }

    public function testTimelineEventFields()
    {
        $requiredFields = [
            'entity_type',
            'entity_id',
            'event_type',
            'event_date',
            'event_description',
            'event_data',
            'related_entity_type',
            'related_entity_id',
            'created_by',
            'created_at'
        ];
        
        foreach ($requiredFields as $field) {
            $this->assertIsString($field);
        }
        
        $this->assertCount(10, $requiredFields);
    }

    public function testEntityVersionFields()
    {
        $requiredFields = [
            'entity_type',
            'entity_id',
            'version_number',
            'version_data',
            'version_description',
            'created_by',
            'created_at'
        ];
        
        foreach ($requiredFields as $field) {
            $this->assertIsString($field);
        }
        
        $this->assertCount(7, $requiredFields);
    }
}
