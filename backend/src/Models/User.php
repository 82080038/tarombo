<?php
/**
 * User Model
 * Authentication and user management
 */

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class User extends Model
{
    protected $table = 'users';
    
    protected $fillable = [
        'email',
        'password',
        'nama',
        'role',
        'person_id',
        'status',
        'email_verified_at'
    ];
    
    protected $casts = [
        'email_verified_at' => 'datetime',
    ];
    
    protected $hidden = [
        'password'
    ];
    
    public $timestamps = true;
    
    /**
     * Relationship to Person
     */
    public function person()
    {
        return $this->belongsTo(Person::class, 'person_id');
    }
    
    /**
     * Check if user has a specific role
     */
    public function hasRole(string $role): bool
    {
        return $this->role === $role;
    }
    
    /**
     * Check if user is admin
     */
    public function isAdmin(): bool
    {
        return in_array($this->role, ['admin', 'tetua']);
    }
    
    /**
     * Check if user can manage persons
     */
    public function canManagePersons(): bool
    {
        return in_array($this->role, ['admin', 'tetua', 'verified', 'user']);
    }
}
