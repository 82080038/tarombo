<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Model;
class Event extends Model
{
    protected $table = 'events';
    protected $fillable = ['judul', 'deskripsi', 'tipe', 'tanggal_mulai', 'tanggal_selesai', 'lokasi', 'latitude', 'longitude', 'punguan_id', 'person_id', 'max_peserta', 'status', 'reminder_sent', 'created_by'];
    protected $casts = ['tanggal_mulai' => 'datetime', 'tanggal_selesai' => 'datetime', 'latitude' => 'decimal:8', 'longitude' => 'decimal:8', 'reminder_sent' => 'boolean', 'created_at' => 'datetime', 'updated_at' => 'datetime'];
    public function punguan() { return $this->belongsTo(Punguan::class, 'punguan_id'); }
    public function person() { return $this->belongsTo(Person::class, 'person_id'); }
    public function creator() { return $this->belongsTo(User::class, 'created_by'); }
    public function attendees() { return $this->hasMany(EventAttendee::class, 'event_id'); }
}
