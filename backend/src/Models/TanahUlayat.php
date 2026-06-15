<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Model;
class TanahUlayat extends Model
{
    protected $table = 'tanah_ulayat';
    protected $fillable = ['nama', 'marga_id', 'deskripsi', 'luas_hektar', 'lokasi', 'latitude', 'longitude', 'batas_wilayah', 'status', 'pengelola_id', 'foto_path', 'peta_path'];
    protected $casts = ['luas_hektar' => 'decimal:2', 'latitude' => 'decimal:8', 'longitude' => 'decimal:8', 'created_at' => 'datetime', 'updated_at' => 'datetime'];
    public function marga() { return $this->belongsTo(Marga::class, 'marga_id'); }
    public function pengelola() { return $this->belongsTo(Person::class, 'pengelola_id'); }
    public function boundaries() { return $this->hasMany(TanahBoundary::class, 'tanah_ulayat_id'); }
}
