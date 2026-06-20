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
        'nama_depan',
        'marga_id',
        'id_turunan_marga',
        'id_asal_usul',
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
     * Turunan Marga (descendant marga) relationship
     * For tracking marga hierarchy
     */
    public function turunanMarga(): BelongsTo
    {
        return $this->belongsTo(Marga::class, 'id_turunan_marga');
    }
    
    /**
     * Asal Usul Marga (origin marga) relationship
     * For verifying marga origin
     */
    public function asalUsulMarga(): BelongsTo
    {
        return $this->belongsTo(Marga::class, 'id_asal_usul');
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
     * All children (as father or mother) - returns query builder
     */
    public function allChildren()
    {
        return Person::where(function ($q) {
            $q->where('father_id', $this->id)
              ->orWhere('mother_id', $this->id);
        });
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
     * Spouses - get all spouses via marriages table
     */
    public function spouses()
    {
        $spouseIds = Marriage::where('husband_id', $this->id)
            ->pluck('wife_id')
            ->merge(
                Marriage::where('wife_id', $this->id)->pluck('husband_id')
            )
            ->unique()
            ->values();

        return Person::whereIn('id', $spouseIds);
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
            ->filter(fn($s) => $s->jenis_kelamin === 'L')
            ->values()
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
            ->filter(fn($s) => $s->jenis_kelamin === 'P')
            ->values()
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
     * Uses nama_depan if available, otherwise nama
     */
    public function getFullNameAttribute(): string
    {
        $nama = $this->nama_depan ?? $this->nama;
        return trim($nama . ' ' . $this->marga?->nama);
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
    
    /**
     * Calculate Bere (children of sisters) - BR-BER-001
     * Formula: SAUDARA PEREMPUAN → ANAK
     */
    public function getBere(): array
    {
        $bere = [];
        $sisters = $this->siblings()->filter(fn($s) => $s->jenis_kelamin === 'P');
        foreach ($sisters as $sister) {
            foreach ($sister->childrenAsMother as $child) {
                $bere[] = [
                    'person' => $child->toArray(),
                    'through_sister' => $sister->nama,
                    'relation' => 'Anak dari saudara perempuan (Bere)'
                ];
            }
        }
        return $bere;
    }
    
    /**
     * Find Pariban candidates (ideal match per adat) - BR-PAR-001, BR-PAR-002
     * For male: anak perempuan dari Tulang (saudara laki ibu)
     * For female: anak laki-laki dari Namboru (saudara perempuan ayah)
     */
    public function getParibanCandidates(): array
    {
        $candidates = [];
        
        if ($this->jenis_kelamin === 'L') {
            // Male looking for: daughter of mother's brother (Tulang's daughter)
            if ($this->mother) {
                $tulangList = $this->mother->siblings()->filter(fn($s) => $s->jenis_kelamin === 'L');
                foreach ($tulangList as $tulang) {
                    foreach ($tulang->childrenAsFather as $child) {
                        if ($child->jenis_kelamin === 'P') {
                            $candidates[] = [
                                'person' => $child->toArray(),
                                'through' => 'Tulang: ' . $tulang->nama,
                                'relation_type' => 'Anak perempuan dari Tulang (saudara laki ibu)',
                                'match_score' => $this->calculateMatchScore($child)
                            ];
                        }
                    }
                }
            }
        } else {
            // Female looking for: son of father's sister (Namboru's son)
            if ($this->father) {
                $namboruList = $this->father->siblings()->filter(fn($s) => $s->jenis_kelamin === 'P');
                foreach ($namboruList as $namboru) {
                    foreach ($namboru->childrenAsMother as $child) {
                        if ($child->jenis_kelamin === 'L') {
                            $candidates[] = [
                                'person' => $child->toArray(),
                                'through' => 'Namboru: ' . $namboru->nama,
                                'relation_type' => 'Anak laki-laki dari Namboru (saudara perempuan ayah)',
                                'match_score' => $this->calculateMatchScore($child)
                            ];
                        }
                    }
                }
            }
        }
        
        return $candidates;
    }
    
    /**
     * Simple match score based on age difference and same sub-suku
     */
    private function calculateMatchScore(Person $candidate): int
    {
        $score = 50; // base score
        
        // Same sub-suku bonus
        if ($this->marga && $candidate->marga && $this->marga->sub_suku === $candidate->marga->sub_suku) {
            $score += 20;
        }
        
        // Age difference bonus (closer = better)
        if ($this->tanggal_lahir && $candidate->tanggal_lahir) {
            $ageDiff = abs(strtotime($this->tanggal_lahir) - strtotime($candidate->tanggal_lahir));
            $yearsDiff = $ageDiff / (365 * 24 * 60 * 60);
            if ($yearsDiff < 5) $score += 30;
            elseif ($yearsDiff < 10) $score += 15;
            elseif ($yearsDiff < 20) $score += 5;
        } else {
            $score += 10; // unknown age = moderate score
        }
        
        return min(100, $score);
    }
}
