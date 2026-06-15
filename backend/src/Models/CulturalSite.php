<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Model;
class CulturalSite extends Model
{
    protected $table = 'cultural_sites';
    protected $fillable = ['nama', 'tipe', 'deskripsi', 'alamat', 'kota', 'provinsi', 'latitude', 'longitude', 'marga_id', 'person_id', 'sejarah', 'status_konservasi', 'foto_path', 'created_by'];
    protected $casts = ['latitude' => 'decimal:10,8', 'longitude' => 'decimal:11,8', 'created_at' => 'datetime', 'updated_at' => 'datetime'];
    public function marga() { return $this->belongsTo(Marga::class, 'marga_id'); }
    public function person() { return $this->belongsTo(Person::class, 'person_id'); }
    public function creator() { return $this->belongsTo(User::class, 'created_by'); }
}
