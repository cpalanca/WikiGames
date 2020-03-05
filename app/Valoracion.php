<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Valoracion extends Model
{
    //id, idusuario, idjuego, valoración
    protected $table = 'valoracion';
    public $timestamps = false;

    protected $fillable = [
        'idusuario', 'idjuego', 'valoracion'
    ];

    public function usuario() {
        return $this->belongsTo('App\Usuario', 'idusuario');
    }
    
    public function juego() {
        return $this->belongsTo('App\Juego', 'idjuego');
    }
}
