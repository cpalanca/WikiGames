<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Comentario extends Model
{
    //idusuario, idjuego, fecha, comentario
    protected $table = 'comentario';
    public $timestamps = false;

    protected $fillable = [
        'idusuario', 'idjuego', 'fecha', 'comentario'
    ];

    public function usuario() {
        return $this->belongsTo('App\Usuario', 'idusuario');
    }
    
    public function juego() {
        return $this->belongsTo('App\Juego', 'idjuego');
    }
}
