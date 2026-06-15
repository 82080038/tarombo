<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Model;
class OralTradition extends Model
{
    protected $table = 'oral_traditions';
    protected $fillable = ['kategori', 'judul', 'konten', 'bahasa_asli', 'terjemahan', 'transliterasi', 'audio_path', 'video_path', 'marga_id', 'daerah', 'narator', 'tanggal_rekam', 'status', 'created_by'];
    protected $casts = ['tanggal_rekam' => 'date', 'created_at' => 'datetime', 'updated_at' => 'datetime'];
    public function marga() { return $this->belongsTo(Marga::class, 'marga_id'); }
    public function creator() { return $this->belongsTo(User::class, 'created_by'); }
}
