<?php
/**
 * Marriage Model
 * Represents a marriage relationship
 */

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Marriage extends Model
{
    protected $table = 'marriages';
    
    protected $fillable = [
        'husband_id',
        'wife_id',
        'tanggal_perkawinan',
        'tempat_perkawinan',
        'status',
        'hula_hula_marga_id',  // Pihak pemberi perempuan (BR-HUL)
        'boru_marga_id',       // Pihak menerima perempuan (BR-BOR)
        'created_by',
        'verified_by',
        'verified_at'
    ];
    
    protected $casts = [
        'tanggal_perkawinan' => 'date',
        'verified_at' => 'datetime',
    ];
    
    /**
     * Husband relationship
     */
    public function husband(): BelongsTo
    {
        return $this->belongsTo(Person::class, 'husband_id');
    }
    
    /**
     * Wife relationship
     */
    public function wife(): BelongsTo
    {
        return $this->belongsTo(Person::class, 'wife_id');
    }
    
    /**
     * Validate same marga (BR-PRK-006)
     */
    public static function validateSameMarga(int $husbandId, int $wifeId): bool
    {
        $husband = Person::find($husbandId);
        $wife = Person::find($wifeId);
        
        if (!$husband || !$wife) {
            return false;
        }
        
        return $husband->marga_id !== $wife->marga_id;
    }
    
    /**
     * Validate forbidden pairs (BR-PRK-007)
     */
    public static function validateForbiddenPairs(int $husbandId, int $wifeId): bool
    {
        $husband = Person::find($husbandId);
        $wife = Person::find($wifeId);
        
        if (!$husband || !$wife) {
            return false;
        }
        
        $forbidden = ForbiddenMargaPair::where(function ($q) use ($husband, $wife) {
            $q->where(function ($q2) use ($husband, $wife) {
                $q2->where('marga_a_id', $husband->marga_id)
                   ->where('marga_b_id', $wife->marga_id);
            })->orWhere(function ($q2) use ($husband, $wife) {
                $q2->where('marga_a_id', $wife->marga_id)
                   ->where('marga_b_id', $husband->marga_id);
            });
        })->exists();
        
        return !$forbidden;
    }
}
