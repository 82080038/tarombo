<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ForbiddenMargaPair extends Model
{
    protected $table = 'forbidden_marga_pairs';
    protected $fillable = ['marga_a_id', 'marga_b_id', 'reason', 'rule_reference'];
    public $timestamps = true;
}
