<?php
/**
 * Marga Model
 * Represents a Batak clan/family name
 */

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Marga extends Model
{
    protected $table = 'marga';
    
    protected $fillable = [
        'nama',
        'sub_suku',
        'deskripsi',
        'asal_usul',
        'status'
    ];
    
    /**
     * Persons belonging to this marga
     */
    public function persons(): HasMany
    {
        return $this->hasMany(Person::class);
    }
    
    /**
     * Active persons count
     */
    public function getActivePersonsCountAttribute(): int
    {
        return $this->persons()->where('status', 'active')->count();
    }
    
    /**
     * Scope by sub-suku
     */
    public function scopeBySubSuku($query, string $subSuku)
    {
        return $query->where('sub_suku', $subSuku);
    }
    
    /**
     * Get all marga for a sub-suku
     */
    public static function getBySubSuku(string $subSuku): array
    {
        return self::where('sub_suku', $subSuku)
            ->where('status', 'active')
            ->orderBy('nama')
            ->get()
            ->toArray();
    }
}
