<?php
/**
 * Marriage Stage Model
 * Tracks Batak marriage ceremony stages
 */

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class MarriageStage extends Model
{
    protected $table = 'marriage_stages';
    
    protected $fillable = [
        'marriage_id',
        'stage_name',
        'stage_order',
        'status',
        'stage_date',
        'stage_location',
        'details'
    ];
    
    protected $casts = [
        'stage_date' => 'date',
        'details' => 'array',
    ];
    
    public $timestamps = true;
    
    public function marriage()
    {
        return $this->belongsTo(Marriage::class, 'marriage_id');
    }
    
    /**
     * Default Batak marriage stages
     */
    public static function defaultStages(): array
    {
        return [
            ['stage_name' => 'Mangarisika', 'stage_order' => 1],
            ['stage_name' => 'Martumpol', 'stage_order' => 2],
            ['stage_name' => 'Martonggo Raja', 'stage_order' => 3],
            ['stage_name' => 'Marsibuha Buhai', 'stage_order' => 4],
            ['stage_name' => 'Pemberkatan', 'stage_order' => 5],
            ['stage_name' => 'Mangulosi', 'stage_order' => 6],
            ['stage_name' => 'Paulak Une', 'stage_order' => 7],
        ];
    }
}
