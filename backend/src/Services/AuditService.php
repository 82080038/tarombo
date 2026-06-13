<?php
/**
 * Audit Service
 * Logs all changes to person data
 */

namespace App\Services;

use App\Models\Person;
use Illuminate\Database\Eloquent\Model;

class AuditService
{
    /**
     * Log an action
     */
    public function log(
        string $action,
        Model $entity,
        ?int $performedBy,
        ?array $oldValues = null,
        ?array $newValues = null
    ): void {
        // For now, just log to file
        // In production, this should go to database table
        $logEntry = [
            'timestamp' => now()->toIso8601String(),
            'action' => $action,
            'entity_type' => get_class($entity),
            'entity_id' => $entity->id,
            'performed_by' => $performedBy,
            'old_values' => $oldValues,
            'new_values' => $newValues,
        ];
        
        $this->writeToLog($logEntry);
    }
    
    /**
     * Write to log file
     */
    private function writeToLog(array $data): void
    {
        $logFile = __DIR__ . '/../../logs/audit.log';
        $logDir = dirname($logFile);
        
        if (!is_dir($logDir)) {
            mkdir($logDir, 0755, true);
        }
        
        $logLine = json_encode($data) . PHP_EOL;
        file_put_contents($logFile, $logLine, FILE_APPEND);
    }
}
