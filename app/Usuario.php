<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Usuario extends Model
{
    //
    protected $table = 'usuario';
    public $timestamps = false;

    protected $fillable = [
        'alias', 'correo', 'password'
    ];

    public function valoraciones() {
        return $this->hasMany('App\Valoracion');
    }
    
    public function comentarios() {
        return $this->hasMany('App\Comentario');
    }
}
