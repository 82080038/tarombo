<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Model;
class Message extends Model
{
    protected $table = 'messages';
    protected $fillable = ['pengirim_id', 'penerima_id', 'subjek', 'konten', 'status', 'parent_id'];
    protected $casts = ['created_at' => 'datetime'];
    public function pengirim() { return $this->belongsTo(User::class, 'pengirim_id'); }
    public function penerima() { return $this->belongsTo(User::class, 'penerima_id'); }
    public function parent() { return $this->belongsTo(Message::class, 'parent_id'); }
    public function replies() { return $this->hasMany(Message::class, 'parent_id'); }
}
