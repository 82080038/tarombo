<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Punguan extends Model
{
    protected $table = 'punguan';
    protected $fillable = ['nama', 'marga_id', 'deskripsi', 'alamat', 'kota', 'provinsi', 'ketua_id', 'wakil_ketua_id', 'sekretaris_id', 'bendahara_id', 'status'];
    public $timestamps = true;

    public function marga() { return $this->belongsTo(Marga::class, 'marga_id'); }
    public function ketua() { return $this->belongsTo(Person::class, 'ketua_id'); }
    public function members() { return $this->hasMany(PunguanMember::class, 'punguan_id'); }
    public function iuran() { return $this->hasMany(Iuran::class, 'punguan_id'); }
}
