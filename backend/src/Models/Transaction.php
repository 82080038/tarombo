<?php
/**
 * Transaction Model
 * Manages punguan financial transactions
 */

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Transaction extends Model
{
    protected $table = 'transactions';
    protected $fillable = [
        'punguan_id', 'tipe', 'kategori', 'jumlah', 'tanggal', 'deskripsi',
        'person_id', 'bukti_dokumen_id', 'status', 'verified_by', 'verified_at'
    ];
    protected $casts = [
        'jumlah' => 'decimal:2',
        'tanggal' => 'date',
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

    public function dokumen()
    {
        return $this->belongsTo(Document::class, 'bukti_dokumen_id');
    }

    public function verifier()
    {
        return $this->belongsTo(User::class, 'verified_by');
    }
}
