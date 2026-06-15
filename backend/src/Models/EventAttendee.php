<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Model;
class EventAttendee extends Model
{
    protected $table = 'event_attendees';
    protected $fillable = ['event_id', 'person_id', 'status', 'catatan', 'tanggal_respon'];
    protected $casts = ['tanggal_respon' => 'datetime', 'created_at' => 'datetime'];
    public function event() { return $this->belongsTo(Event::class, 'event_id'); }
    public function person() { return $this->belongsTo(Person::class, 'person_id'); }
}
