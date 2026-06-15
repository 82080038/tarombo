<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Model;
class Story extends Model
{
    protected $table = 'stories';
    protected $fillable = ['judul', 'tipe', 'konten', 'person_id', 'penulis_id', 'marga_id', 'tanggal_kejadian', 'lokasi', 'status'];
    protected $casts = ['tanggal_kejadian' => 'date', 'created_at' => 'datetime', 'updated_at' => 'datetime'];
    public function person() { return $this->belongsTo(Person::class, 'person_id'); }
    public function penulis() { return $this->belongsTo(User::class, 'penulis_id'); }
    public function marga() { return $this->belongsTo(Marga::class, 'marga_id'); }
}
