<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class PunguanMember extends Model
{
    protected $table = 'punguan_members';
    protected $fillable = ['punguan_id', 'person_id', 'role', 'join_date', 'status'];
    public $timestamps = true;

    public function punguan() { return $this->belongsTo(Punguan::class, 'punguan_id'); }
    public function person() { return $this->belongsTo(Person::class, 'person_id'); }
}
