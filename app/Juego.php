<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Juego extends Model
{
    //título, carátula, tipo, fecha lanzamiento, descripción
    protected $table = 'juego';
    public $timestamps = false;

    protected $fillable = [
        'titulo', 'caratula', 'tipo', 'flanzamiento', 'descripcion'
    ];

    public function valoraciones() {
        return $this->hasMany('App\Valoracion');
    }
    
    public function comentarios() {
        return $this->hasMany('App\Comentario');
    }
}
