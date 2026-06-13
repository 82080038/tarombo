<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Ceremony extends Model
{
    protected $table = 'ceremonies';
    protected $fillable = [
        'ceremony_type', 'ceremony_name', 'marriage_id',
        'ceremony_date', 'ceremony_location', 'raja_parhata_id',
        'hula_hula_marga_id', 'boru_marga_id', 'status', 'notes', 'created_by'
    ];
    protected $casts = [
        'ceremony_date' => 'date',
    ];
    public $timestamps = true;

    public function marriage()
    {
        return $this->belongsTo(Marriage::class, 'marriage_id');
    }

    public function rajaParhata()
    {
        return $this->belongsTo(Person::class, 'raja_parhata_id');
    }
}
