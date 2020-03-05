<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class Valoracion extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        //Valoración: id, idusuario, idjuego, valoración (idusuario e idjuego juntos son únicos)
        Schema::create('valoracion', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->bigInteger('idusuario')->unsigned();
            $table->bigInteger('idjuego')->unsigned();
            $table->decimal('valoracion', 4, 2);
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
         Schema::dropIfExists('valoracion');
    }
}
