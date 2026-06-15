<?php
/**
 * Asset Model
 * Manages family assets and inheritance
 */

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Asset extends Model
{
    protected $table = 'assets';
    protected $fillable = [
        'nama', 'tipe', 'deskripsi', 'nilai_estimasi', 'tanggal_perolehan',
        'cara_perolehan', 'lokasi', 'latitude', 'longitude', 'foto_path',
        'status', 'pemilik_saat_ini_id', 'marga_id', 'created_by'
    ];
    protected $casts = [
        'nilai_estimasi' => 'decimal:2',
        'tanggal_perolehan' => 'date',
        'latitude' => 'decimal:8',
        'longitude' => 'decimal:8',
        'created_at' => 'datetime',
        'updated_at' => 'datetime'
    ];

    public function pemilik()
    {
        return $this->belongsTo(Person::class, 'pemilik_saat_ini_id');
    }

    public function marga()
    {
        return $this->belongsTo(Marga::class, 'marga_id');
    }

    public function inheritanceRecords()
    {
        return $this->hasMany(InheritanceRecord::class, 'asset_id');
    }

    public function creator()
    {
        return $this->belongsTo(User::class, 'created_by');
    }
}
