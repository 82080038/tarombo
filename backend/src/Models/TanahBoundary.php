<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Model;
class TanahBoundary extends Model
{
    protected $table = 'tanah_boundaries';
    protected $fillable = ['tanah_ulayat_id', 'titik_urutan', 'latitude', 'longitude', 'deskripsi_titik'];
    protected $casts = ['latitude' => 'decimal:8', 'longitude' => 'decimal:8', 'created_at' => 'datetime'];
    public function tanahUlayat() { return $this->belongsTo(TanahUlayat::class, 'tanah_ulayat_id'); }
}
