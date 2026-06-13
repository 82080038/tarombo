<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Document extends Model
{
    protected $table = 'documents';
    protected $fillable = ['document_type', 'title', 'description', 'file_path', 'file_size', 'mime_type', 'access_level', 'person_id', 'ceremony_id', 'punguan_id', 'uploaded_by'];
    public $timestamps = true;

    public function person() { return $this->belongsTo(Person::class, 'person_id'); }
    public function ceremony() { return $this->belongsTo(Ceremony::class, 'ceremony_id'); }
    public function punguan() { return $this->belongsTo(Punguan::class, 'punguan_id'); }
}
