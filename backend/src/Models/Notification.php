<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Model;
class Notification extends Model
{
    protected $table = 'notifications';
    protected $fillable = ['user_id', 'title', 'message', 'type', 'entity_type', 'entity_id', 'action', 'is_read', 'read_at'];
    protected $casts = ['created_at' => 'datetime', 'read_at' => 'datetime', 'is_read' => 'boolean'];
    public function user() { return $this->belongsTo(User::class, 'user_id'); }
}
