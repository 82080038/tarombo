<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Model;
class Tradition extends Model
{
    protected $table = 'traditions';
    protected $fillable = ['nama', 'kategori', 'deskripsi', 'asal_usul', 'prosedur', 'marga_id', 'status', 'created_by'];
    protected $casts = ['created_at' => 'datetime', 'updated_at' => 'datetime'];
    public function marga() { return $this->belongsTo(Marga::class, 'marga_id'); }
    public function creator() { return $this->belongsTo(User::class, 'created_by'); }
}
