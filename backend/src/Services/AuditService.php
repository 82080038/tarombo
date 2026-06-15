<?php
/**
 * Audit Service
 * Logs all changes to entities using database entity_history table
 */

namespace App\Services;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;

class AuditService
{
    private ?NotificationService $notificationService = null;
    
    public function setNotificationService(NotificationService $notificationService): void
    {
        $this->notificationService = $notificationService;
    }
    
    /**
     * Log an action to entity_history table
     */
    public function log(
        string $action,
        Model $entity,
        ?int $performedBy,
        ?array $oldValues = null,
        ?array $newValues = null,
        ?string $reason = null
    ): void {
        $entityType = $this->getEntityName($entity);
        $entityId = $entity->getKey();
        
        DB::table('entity_history')->insert([
            'entity_type' => $entityType,
            'entity_id' => $entityId,
            'action' => $action,
            'changed_by' => $performedBy,
            'old_values' => $oldValues ? json_encode($oldValues) : null,
            'new_values' => $newValues ? json_encode($newValues) : null,
            'reason' => $reason,
            'changed_at' => now()
        ]);
        
        // Trigger notification if service is available
        if ($this->notificationService) {
            $this->notificationService->notifyEntityChange(
                $performedBy,
                $entityType,
                $entityId,
                $action
            );
        }
    }
    
    /**
     * Get history for an entity
     */
    public function getEntityHistory(string $entityType, int $entityId): array
    {
        return DB::table('entity_history')
            ->where('entity_type', $entityType)
            ->where('entity_id', $entityId)
            ->orderBy('changed_at', 'desc')
            ->get()
            ->toArray();
    }
    
    /**
     * Log timeline event
     */
    public function logTimelineEvent(
        string $entityType,
        int $entityId,
        string $eventType,
        string $eventDate,
        string $eventDescription,
        ?array $eventData = null,
        ?string $relatedEntityType = null,
        ?int $relatedEntityId = null,
        ?int $createdBy = null
    ): void {
        DB::table('entity_timeline')->insert([
            'entity_type' => $entityType,
            'entity_id' => $entityId,
            'event_type' => $eventType,
            'event_date' => $eventDate,
            'event_description' => $eventDescription,
            'event_data' => json_encode($eventData),
            'related_entity_type' => $relatedEntityType,
            'related_entity_id' => $relatedEntityId,
            'created_by' => $createdBy,
            'created_at' => now()
        ]);
    }
    
    /**
     * Create entity version
     */
    public function createEntityVersion(
        string $entityType,
        int $entityId,
        int $versionNumber,
        array $versionData,
        ?string $versionDescription = null,
        ?int $createdBy = null
    ): void {
        DB::table('entity_version')->insert([
            'entity_type' => $entityType,
            'entity_id' => $entityId,
            'version_number' => $versionNumber,
            'version_data' => json_encode($versionData),
            'version_description' => $versionDescription,
            'created_by' => $createdBy,
            'created_at' => now()
        ]);
    }
}
