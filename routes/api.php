<?php

use Illuminate\Http\Request;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::middleware('auth:api')->get('/user', function (Request $request) {
    return $request->user();
});

Route::resource('usuario', 'UsuarioController', ['except'=> ['create', 'edit']]);
Route::resource('juego', 'JuegoController', ['except'=> ['create', 'edit']]);
Route::resource('comentario', 'ComentarioController', ['except'=> ['create', 'edit']]);
Route::resource('valoracion', 'ValoracionController', ['except'=> ['create', 'edit']]);
Route::post('uploads', 'JuegoController@upload');
Route::get('usuario/{alias}/{clave}', 'UsuarioController@correctPass');
Route::get('getinfousuario/{alias}', 'UsuarioController@getInfoUsuario');
Route::post('usuario/recoverypass', 'UsuarioController@resetPassword');
Route::get('valoracion/valoracionesusuario/{alias}', 'ValoracionController@valoracionesusuario');
Route::get('comentario/comentariosjuego/{idjuego}', 'ComentarioController@comentariosJuego');
Route::get('comentario/comentariosusuario/{alias}', 'ComentarioController@comentariosUsuario');
Route::get('juego/interaccion/{alias}', 'JuegoController@juegosInteractuados');