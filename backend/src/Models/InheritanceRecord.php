<?php
/**
 * Inheritance Record Model
 * Tracks asset ownership transfers
 */

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class InheritanceRecord extends Model
{
    protected $table = 'inheritance_records';
    protected $fillable = [
        'asset_id', 'pemilik_lama_id', 'pemilik_baru_id', 'tanggal_transfer',
        'cara_transfer', 'alasan_transfer', 'saksi_id', 'dokumen_id', 'catatan'
    ];
    protected $casts = [
        'tanggal_transfer' => 'date',
        'created_at' => 'datetime'
    ];

    public function asset()
    {
        return $this->belongsTo(Asset::class, 'asset_id');
    }

    public function pemilikLama()
    {
        return $this->belongsTo(Person::class, 'pemilik_lama_id');
    }

    public function pemilikBaru()
    {
        return $this->belongsTo(Person::class, 'pemilik_baru_id');
    }

    public function saksi()
    {
        return $this->belongsTo(Person::class, 'saksi_id');
    }

    public function dokumen()
    {
        return $this->belongsTo(Document::class, 'dokumen_id');
    }
}
