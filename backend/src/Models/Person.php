<?php
/**
 * Person Model
 * Represents an individual in the family tree
 */

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;

class Person extends Model
{
    protected $table = 'persons';
    
    protected $fillable = [
        'nama',
        'marga_id',
        'jenis_kelamin',
        'father_id',
        'mother_id',
        'tanggal_lahir',
        'tempat_lahir',
        'tanggal_meninggal',
        'status',
        'created_by',
        'verified_by',
        'verified_at'
    ];
    
    protected $casts = [
        'tanggal_lahir' => 'date',
        'tanggal_meninggal' => 'date',
        'verified_at' => 'datetime',
    ];
    
    /**
     * Marga (clan) relationship - BR-MRG-001 Patrilineal
     */
    public function marga(): BelongsTo
    {
        return $this->belongsTo(Marga::class);
    }
    
    /**
     * Father relationship
     */
    public function father(): BelongsTo
    {
        return $this->belongsTo(Person::class, 'father_id');
    }
    
    /**
     * Mother relationship
     */
    public function mother(): BelongsTo
    {
        return $this->belongsTo(Person::class, 'mother_id');
    }
    
    /**
     * Children where this person is father
     */
    public function childrenAsFather(): HasMany
    {
        return $this->hasMany(Person::class, 'father_id');
    }
    
    /**
     * Children where this person is mother
     */
    public function childrenAsMother(): HasMany
    {
        return $this->hasMany(Person::class, 'mother_id');
    }
    
    /**
     * All children
     */
    public function allChildren()
    {
        return $this->childrenAsFather->merge($this->childrenAsMother);
    }
    
    /**
     * Marriages
     */
    public function marriagesAsHusband(): HasMany
    {
        return $this->hasMany(Marriage::class, 'husband_id');
    }
    
    public function marriagesAsWife(): HasMany
    {
        return $this->hasMany(Marriage::class, 'wife_id');
    }
    
    /**
     * Spouses
     */
    public function spouses(): BelongsToMany
    {
        return $this->belongsToMany(
            Person::class,
            'marriages',
            'husband_id',
            'wife_id'
        )->union(
            $this->belongsToMany(
                Person::class,
                'marriages',
                'wife_id',
                'husband_id'
            )
        );
    }
    
    /**
     * Calculate Tulang (mother's brothers) - BR-TUL-001
     * Formula: IBU → SAUDARA LAKI-LAKI
     */
    public function getTulang(): array
    {
        if (!$this->mother) {
            return [];
        }
        
        return $this->mother->siblings()
            ->where('jenis_kelamin', 'L')
            ->get()
            ->toArray();
    }
    
    /**
     * Calculate Namboru (father's sisters) - BR-NBR-001
     * Formula: AYAH → SAUDARA PEREMPUAN
     */
    public function getNamboru(): array
    {
        if (!$this->father) {
            return [];
        }
        
        return $this->father->siblings()
            ->where('jenis_kelamin', 'P')
            ->get()
            ->toArray();
    }
    
    /**
     * Siblings
     */
    public function siblings()
    {
        return Person::where(function ($query) {
            $query->where('father_id', $this->father_id)
                  ->orWhere('mother_id', $this->mother_id);
        })
        ->where('id', '!=', $this->id)
        ->get();
    }
    
    /**
     * Get full name with marga
     */
    public function getFullNameAttribute(): string
    {
        return $this->nama . ' ' . $this->marga?->nama;
    }
    
    /**
     * Scope for active persons
     */
    public function scopeActive($query)
    {
        return $query->where('status', 'active');
    }
    
    /**
     * Scope by marga
     */
    public function scopeByMarga($query, int $margaId)
    {
        return $query->where('marga_id', $margaId);
    }
}
