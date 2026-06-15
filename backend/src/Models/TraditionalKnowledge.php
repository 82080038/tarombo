<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Model;
class TraditionalKnowledge extends Model
{
    protected $table = 'traditional_knowledge';
    protected $fillable = ['kategori', 'judul', 'deskripsi', 'metode', 'bahan', 'alat', 'manfaat', 'larangan', 'marga_id', 'daerah', 'pengetahuan_dari', 'tanggal_dokumentasi', 'foto_path', 'video_path', 'status', 'created_by'];
    protected $casts = ['tanggal_dokumentasi' => 'date', 'created_at' => 'datetime', 'updated_at' => 'datetime'];
    public function marga() { return $this->belongsTo(Marga::class, 'marga_id'); }
    public function creator() { return $this->belongsTo(User::class, 'created_by'); }
}
