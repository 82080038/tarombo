<?php
/**
 * Budget Model
 * Manages punguan budgets
 */

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Budget extends Model
{
    protected $table = 'budgets';
    protected $fillable = [
        'punguan_id', 'tahun', 'kategori', 'anggaran', 'terpakai', 'deskripsi', 'created_by'
    ];
    protected $casts = [
        'anggaran' => 'decimal:2',
        'terpakai' => 'decimal:2',
        'created_at' => 'datetime',
        'updated_at' => 'datetime'
    ];

    public function punguan()
    {
        return $this->belongsTo(Punguan::class, 'punguan_id');
    }

    public function creator()
    {
        return $this->belongsTo(User::class, 'created_by');
    }
}
