<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class Comentario extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        //Comentario: id, idusuario, idjuego, fecha, comentario
        Schema::create('comentario', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->bigInteger('idusuario')->unsigned();
            $table->bigInteger('idjuego')->unsigned();
            $table->date('fecha');
            $table->text('comentario');
            $table->foreign('idusuario')->references('id')->on('usuario');
            $table->foreign('idjuego')->references('id')->on('juego');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        //
        Schema::dropIfExists('comentario');
    }
}
