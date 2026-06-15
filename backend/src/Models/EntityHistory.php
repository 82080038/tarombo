<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Model;
class EntityHistory extends Model
{
    protected $table = 'entity_history';
    protected $fillable = ['entity_type', 'entity_id', 'action', 'old_data', 'new_data', 'changed_fields', 'changed_by', 'reason', 'ip_address', 'user_agent'];
    protected $casts = ['old_data' => 'json', 'new_data' => 'json', 'changed_fields' => 'json', 'changed_at' => 'datetime'];
    public function user() { return $this->belongsTo(User::class, 'changed_by'); }
    public static function logChange($entityType, $entityId, $action, $oldData = null, $newData = null, $changedBy = null, $reason = null) {
        return self::create([
            'entity_type' => $entityType,
            'entity_id' => $entityId,
            'action' => $action,
            'old_data' => $oldData,
            'new_data' => $newData,
            'changed_fields' => self::getChangedFields($oldData, $newData),
            'changed_by' => $changedBy,
            'reason' => $reason
        ]);
    }
    private static function getChangedFields($oldData, $newData) {
        if (!$oldData || !$newData) return [];
        $old = is_array($oldData) ? $oldData : json_decode($oldData, true);
        $new = is_array($newData) ? $newData : json_decode($newData, true);
        return array_keys(array_diff_assoc($new, $old));
    }
}
