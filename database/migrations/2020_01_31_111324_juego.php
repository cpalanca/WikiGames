<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class Juego extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        //Juego: id, título, carátula, tipo, fecha lanzamiento, descripción (título es único)
        Schema::create('juego', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('titulo')->unique();
            $table->string('caratula');
            $table->string('tipo');
            $table->date('flanzamiento');
            $table->text('descripcion');
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
        Schema::dropIfExists('juego');
    }
}
