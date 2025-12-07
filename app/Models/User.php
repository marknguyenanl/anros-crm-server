<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Foundation\Auth\User as Authenticatable;
use PHPOpenSourceSaver\JWTAuth\Contracts\JWTSubject;

/**
 * Class User
 *
 * @property int $id
 * @property string $email
 * @property Carbon|null $email_verified_at
 * @property string $password
 * @property string|null $remember_token
 * @property Carbon|null $created_at
 * @property Carbon|null $updated_at
 */
class User extends Authenticatable implements JWTSubject
{
    protected $table = 'users';

    protected $casts = [
        'email_verified_at' => 'datetime',
        'password' => 'hashed',
    ];

    protected $hidden = [
        'password',
        'remember_token',
        'email_verified_at',
    ];

    protected $fillable = [
        'email',
        'password'
    ];

    public function getJWTIdentifier(): mixed
    {
        return $this->getKey();
    }

    public function getJWTCustomClaims(): mixed
    {
        return [];
    }
}
