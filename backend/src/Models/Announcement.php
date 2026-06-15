<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Model;
class Announcement extends Model
{
    protected $table = 'announcements';
    protected $fillable = ['judul', 'konten', 'tipe', 'punguan_id', 'marga_id', 'pengirim_id', 'prioritas', 'status', 'tanggal_publish'];
    protected $casts = ['tanggal_publish' => 'datetime', 'created_at' => 'datetime', 'updated_at' => 'datetime'];
    public function punguan() { return $this->belongsTo(Punguan::class, 'punguan_id'); }
    public function marga() { return $this->belongsTo(Marga::class, 'marga_id'); }
    public function pengirim() { return $this->belongsTo(User::class, 'pengirim_id'); }
}
