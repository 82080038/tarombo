<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Model;
class EntityTimeline extends Model
{
    protected $table = 'entity_timeline';
    protected $fillable = ['entity_type', 'entity_id', 'event_type', 'event_date', 'event_description', 'event_data', 'related_entity_type', 'related_entity_id', 'created_by'];
    protected $casts = ['event_data' => 'json', 'event_date' => 'date', 'created_at' => 'datetime'];
    public function creator() { return $this->belongsTo(User::class, 'created_by'); }
    public static function addEvent($entityType, $entityId, $eventType, $eventDate, $description = null, $eventData = null, $relatedEntityType = null, $relatedEntityId = null, $createdBy = null) {
        return self::create([
            'entity_type' => $entityType,
            'entity_id' => $entityId,
            'event_type' => $eventType,
            'event_date' => $eventDate,
            'event_description' => $description,
            'event_data' => $eventData,
            'related_entity_type' => $relatedEntityType,
            'related_entity_id' => $relatedEntityId,
            'created_by' => $createdBy
        ]);
    }
}
