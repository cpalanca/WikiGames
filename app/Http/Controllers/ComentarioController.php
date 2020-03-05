<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Comentario;

class ComentarioController extends Controller
{
    // metodo get
    public function index()
    {
        /*
            SELECT comentario.id, usuario.alias, comentario.comentario, titulo, caratula, flanzamiento
            FROM comentario 
            INNER JOIN juego ON juego.id = comentario.idjuego
            INNER JOIN usuario ON usuario.id = comentario.idusuario
        */
        
        $comentarios = Comentario::select('comentario.id','usuario.alias', 'juego.titulo',
                                        'juego.caratula', 'comentario.comentario', 'comentario.fecha')
            ->join('juego', 'juego.id', '=', 'comentario.idjuego')
            ->join('usuario', 'usuario.id', '=', 'comentario.idusuario')
            ->get();
        
        return response()->json($comentarios,200);
        //return response()->json(Comentario::all(),200);
    }
   /* public function create()
    {
        return response()->json(['mensaje' => 'create'], 200);
    }*/
    public function store(Request $request)
    {
        try{
        $comentario = Comentario::create($request->all());
        } catch(\Exception $e){
            return response()->json(['error' => $e->getMessage()], 400);
        }
        return response()->json(true, 201);
    }
    public function show($id)
    {
        $comentario = Comentario::find($id);
        return response()->json(['data' => $comentario], 200);
    }
   /* public function edit($id)
    {
        return response()->json(['mensaje' => 'edit'], 200);
    }*/
    
    public function update(Request $request, $id)
    {
        $comentario = Comentario::find($id);
        $status = 400;
        if($comentario != null){
            try{
                $result = $comentario->update($request->all());
                $status = 200;
                return response()->json(true, $status);
            }catch(\Exception $e){
                return response()->json(false, $status);
            }
            return response()->json(false, $status);
        }
        return response()->json(false, $status);
        
        /*
           // return response()->json(['data' => $result], 400);
        }
        try{
            $result = $empleado->update($request->all());
        }catch(\Exception $e){
            error
        }
        return response()->json(['data' => $result], 200);*/
    }
    
    public function destroy($id)
    {
        $result = Comentario::destroy($id);
        if($result){
            return response()->json([], 204);
        }
        return response()->json(['error' => 'data not deleted'], 400);
    }
    
    public function usuario($id)
    {
        //Eloquent
        $comentarios = Comentario::where('idusuario', $id)->get();                                                                                                                                                  
        return response()->json($comentarios, 200);
        
    }
    
    public function juego($id)
    {
        //Eloquent
        $comentarios = Comentario::where('idjuego', $id)->get();                                                                                                                                                  
        return response()->json($comentarios, 200);
        
    }
    
    public function comentariosJuego($idjuego)
    {
        /*
            SELECT comentario.id, usuario.alias, comentario.comentario, titulo, caratula, flanzamiento
            FROM comentario 
            INNER JOIN juego ON juego.id = comentario.idjuego
            INNER JOIN usuario ON usuario.id = comentario.idusuario
            WHERE comentario.idjuego = $idjuego
        */
        $comentarios = Comentario::select('comentario.id','usuario.alias', 'juego.titulo',
                                        'juego.caratula', 'comentario.comentario', 'comentario.fecha')
            ->join('juego', 'juego.id', '=', 'comentario.idjuego')
            ->join('usuario', 'usuario.id', '=', 'comentario.idusuario')
            ->where('comentario.idjuego','=',$idjuego)
            ->orderby('comentario.id','DESC')
            ->get();
        
        return response()->json($comentarios,200);
        //return response()->json(Valoracion::all(),200);
    }
    
    public function comentariosUsuario($alias)
    {
        /*
            SELECT comentario.id, usuario.alias, comentario.comentario, titulo, caratula, flanzamiento
            FROM comentario 
            INNER JOIN juego ON juego.id = comentario.idjuego
            INNER JOIN usuario ON usuario.id = comentario.idusuario
            WHERE usuario.alias = $alias
        */
        $comentarios = Comentario::select('comentario.id','usuario.alias', 'juego.titulo',
                                        'juego.caratula', 'comentario.comentario', 'comentario.fecha')
            ->join('juego', 'juego.id', '=', 'comentario.idjuego')
            ->join('usuario', 'usuario.id', '=', 'comentario.idusuario')
            ->where('usuario.alias','=',$alias)
            ->orderby('comentario.id','DESC')
            ->get();
        
        return response()->json($comentarios,200);
        //return response()->json(Valoracion::all(),200);
    }
}
