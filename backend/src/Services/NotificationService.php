<?php
/**
 * Notification Service
 * Manages user notifications for important changes
 */

namespace App\Services;

use Illuminate\Support\Facades\DB;

class NotificationService
{
    /**
     * Create a notification for a user
     */
    public function create(
        int $userId,
        string $title,
        string $message,
        string $type = 'info',
        ?string $entityType = null,
        ?int $entityId = null,
        ?string $action = null
    ): void {
        DB::table('notifications')->insert([
            'user_id' => $userId,
            'title' => $title,
            'message' => $message,
            'type' => $type,
            'entity_type' => $entityType,
            'entity_id' => $entityId,
            'action' => $action,
            'is_read' => false,
            'created_at' => now()
        ]);
    }
    
    /**
     * Get notifications for a user
     */
    public function getUserNotifications(int $userId, bool $unreadOnly = false): array
    {
        $query = DB::table('notifications')->where('user_id', $userId);
        
        if ($unreadOnly) {
            $query->where('is_read', false);
        }
        
        return $query->orderBy('created_at', 'desc')->get()->toArray();
    }
    
    /**
     * Mark notification as read
     */
    public function markAsRead(int $notificationId): void
    {
        DB::table('notifications')
            ->where('id', $notificationId)
            ->update([
                'is_read' => true,
                'read_at' => now()
            ]);
    }
    
    /**
     * Mark all notifications as read for a user
     */
    public function markAllAsRead(int $userId): void
    {
        DB::table('notifications')
            ->where('user_id', $userId)
            ->where('is_read', false)
            ->update([
                'is_read' => true,
                'read_at' => now()
            ]);
    }
    
    /**
     * Get unread count for a user
     */
    public function getUnreadCount(int $userId): int
    {
        return DB::table('notifications')
            ->where('user_id', $userId)
            ->where('is_read', false)
            ->count();
    }
    
    /**
     * Notify users based on entity changes
     */
    public function notifyEntityChange(
        string $entityType,
        int $entityId,
        string $action,
        string $entityName,
        ?int $changedBy = null
    ): void {
        // Get users who should be notified based on preferences
        $users = DB::table('notification_preferences')
            ->join('users', 'notification_preferences.user_id', '=', 'users.id')
            ->where('users.status', 'active')
            ->get();
        
        foreach ($users as $user) {
            $shouldNotify = false;
            
            switch ($entityType) {
                case 'person':
                    $shouldNotify = $user->notify_on_person_changes;
                    break;
                case 'asset':
                    $shouldNotify = $user->notify_on_asset_changes;
                    break;
                case 'transaction':
                case 'budget':
                case 'iuran':
                    $shouldNotify = $user->notify_on_financial_changes;
                    break;
                case 'oral_tradition':
                case 'traditional_knowledge':
                case 'cultural_site':
                    $shouldNotify = $user->notify_on_cultural_changes;
                    break;
                default:
                    $shouldNotify = $user->notify_on_system_updates;
            }
            
            if ($shouldNotify) {
                $this->create(
                    $user->user_id,
                    $this->getNotificationTitle($entityType, $action),
                    $this->getNotificationMessage($entityType, $action, $entityName),
                    $this->getNotificationType($action),
                    $entityType,
                    $entityId,
                    $action
                );
            }
        }
    }
    
    /**
     * Get notification title based on entity and action
     */
    private function getNotificationTitle(string $entityType, string $action): string
    {
        $entityNames = [
            'person' => 'Anggota Keluarga',
            'asset' => 'Harta Warisan',
            'transaction' => 'Transaksi',
            'budget' => 'Anggaran',
            'oral_tradition' => 'Tradisi Lisan',
            'traditional_knowledge' => 'Pengetahuan Tradisional',
            'cultural_site' => 'Situs Budaya'
        ];
        
        $actionNames = [
            'created' => 'Dibuat',
            'updated' => 'Diperbarui',
            'deleted' => 'Dihapus',
            'transferred' => 'Ditransfer',
            'verified' => 'Diverifikasi'
        ];
        
        $entityName = $entityNames[$entityType] ?? $entityType;
        $actionName = $actionNames[$action] ?? $action;
        
        return "{$entityName} {$actionName}";
    }
    
    /**
     * Get notification message
     */
    private function getNotificationMessage(string $entityType, string $action, string $entityName): string
    {
        $messages = [
            'created' => "{$entityName} telah ditambahkan ke sistem.",
            'updated' => "{$entityName} telah diperbarui.",
            'deleted' => "{$entityName} telah dihapus dari sistem.",
            'transferred' => "{$entityName} telah ditransfer.",
            'verified' => "{$entityName} telah diverifikasi."
        ];
        
        return $messages[$action] ?? "Perubahan pada {$entityName}.";
    }
    
    /**
     * Get notification type based on action
     */
    private function getNotificationType(string $action): string
    {
        $types = [
            'created' => 'success',
            'updated' => 'info',
            'deleted' => 'error',
            'transferred' => 'warning',
            'verified' => 'success'
        ];
        
        return $types[$action] ?? 'info';
    }
}
