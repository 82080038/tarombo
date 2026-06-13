<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class PersonLocation extends Model
{
    protected $table = 'person_locations';
    protected $fillable = ['person_id', 'lokasi', 'latitude', 'longitude', 'address_detail', 'location_type', 'is_primary'];
    public $timestamps = true;

    public function person() { return $this->belongsTo(Person::class, 'person_id'); }
}
