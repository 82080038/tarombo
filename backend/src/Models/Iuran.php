<?php
/**
 * Iuran Model
 * Manages punguan membership dues
 */

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Iuran extends Model
{
    protected $table = 'iuran';
    protected $fillable = [
        'punguan_id', 'person_id', 'jenis_iuran', 'jumlah', 'periode',
        'status', 'verified_by', 'verified_at', 'keterangan'
    ];
    protected $casts = [
        'jumlah' => 'decimal:2',
        'verified_at' => 'datetime',
        'created_at' => 'datetime'
    ];

    public function punguan()
    {
        return $this->belongsTo(Punguan::class, 'punguan_id');
    }

    public function person()
    {
        return $this->belongsTo(Person::class, 'person_id');
    }

    public function verifier()
    {
        return $this->belongsTo(User::class, 'verified_by');
    }
}
