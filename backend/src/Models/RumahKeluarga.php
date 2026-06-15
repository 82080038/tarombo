<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Model;
class RumahKeluarga extends Model
{
    protected $table = 'rumah_keluarga';
    protected $fillable = ['nama', 'person_id', 'alamat', 'kota', 'provinsi', 'latitude', 'longitude', 'tipe', 'status', 'foto_path', 'deskripsi'];
    protected $casts = ['latitude' => 'decimal:8', 'longitude' => 'decimal:8', 'created_at' => 'datetime', 'updated_at' => 'datetime'];
    public function person() { return $this->belongsTo(Person::class, 'person_id'); }
}
