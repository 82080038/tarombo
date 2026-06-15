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
        'punguan_id', 'person_id', 'jumlah', 'periode', 'status', 'tanggal_bayar'
    ];
    protected $casts = [
        'jumlah' => 'decimal:2',
        'tanggal_bayar' => 'date',
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
}
