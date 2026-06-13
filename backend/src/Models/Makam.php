<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Makam extends Model
{
    protected $table = 'makam';
    protected $fillable = ['person_id', 'nama_makam', 'lokasi', 'latitude', 'longitude', 'foto_path', 'deskripsi', 'riwayat_perawatan', 'jalur_ziarah', 'verified_by'];
    protected $casts = ['riwayat_perawatan' => 'array'];
    public $timestamps = true;

    public function person() { return $this->belongsTo(Person::class, 'person_id'); }
}
