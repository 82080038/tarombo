<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class AuditLog extends Model
{
    protected $table = 'audit_logs';
    protected $fillable = ['action', 'entity_type', 'entity_id', 'old_values', 'new_values', 'performed_by'];
    protected $casts = [
        'old_values' => 'array',
        'new_values' => 'array',
    ];
    public $timestamps = false;

    public function performedBy()
    {
        return $this->belongsTo(User::class, 'performed_by');
    }
}
