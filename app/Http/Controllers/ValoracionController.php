<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Valoracion;

class ValoracionController extends Controller
{
    // metodo get
    public function index()
    {
        /*
            SELECT valoracion.id, valoracion, juego.titulo, juego.caratula,  usuario.alias
            FROM valoracion 
            INNER JOIN usuario ON usuario.id = valoracion.idusuario
            INNER JOIN juego ON juego.id = valoracion.idjuego
        */
        
        $valoraciones = Valoracion::select('valoracion.id', 'valoracion.idjuego', 'usuario.alias', 'juego.titulo',
                                         'valoracion', 'juego.caratula', 'usuario.alias')
            ->join('usuario', 'usuario.id', '=', 'valoracion.idusuario')
            ->join('juego', 'juego.id', '=', 'valoracion.idjuego')
            ->get();
        
        return response()->json($valoraciones,200);
        //return response()->json(Valoracion::all(),200);
    }
   /* public function create()
    {
        return response()->json(['mensaje' => 'create'], 200);
    }*/
    public function store(Request $request)
    {
        $valoracion = DB::table('valoracion')
        ->where('idusuario', '=', $request->idusuario)
        ->where('idjuego', '=', $request->idjuego)
        ->first();
        //sino existe devuelvo false
        if($valoracion){
             return response()->json(false, 200);
        }else{
            try{
                $valoracion = Valoracion::create($request->all());
            } catch(\Exception $e){
                return response()->json(['error' => $e->getMessage()], 400);
            }
            return response()->json(true, 201);
        }
        return response()->json(false, 200);
    }
    public function show($id)
    {
        $valoracion = Valoracion::find($id);
        return response()->json(['data' => $valoracion], 200);
    }
   /* public function edit($id)
    {
        return response()->json(['mensaje' => 'edit'], 200);
    }*/
    
      
    
    public function update(Request $request, $id)
    {
        $valoracion = Valoracion::find($id);
        $array = ['error' => 'data not deleted'];
        $status = 400;
        if($valoracion != null){
            try{
                $result = $valoracion->update($request->all());
                $array = $valoracion;
                $status = 200;
                return response()->json(true, $status);
            }catch(\Exception $e){
                return response()->json(var_export($request), $status);   
            }
        }
        return response()->json(var_export($request), $status);
        
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
        $result = Valoracion::destroy($id);
        if($result){
            return response()->json([], 204);
        }
        return response()->json(['error' => 'data not deleted'], 400);
    }
    
    public function usuario($id)
    {
        //Eloquent
        $valoraciones = Valoracion::where('idusuario', $id)->get();                                                                                                                                                  
        return response()->json($valoraciones, 200);
        
    }
    
    public function juego($id)
    {
        //Eloquent
        $valoraciones = Valoracion::where('idjuego', $id)->get();                                                                                                                                                  
        return response()->json($valoraciones, 200);
    }
    
    public function valoracionesUsuario($alias)
    {
        /*
            SELECT valoracion.id, valoracion, juego.titulo, juego.caratula,  usuario.alias
            FROM valoracion 
            INNER JOIN usuario ON usuario.id = valoracion.idusuario
            INNER JOIN juego ON juego.id = valoracion.idjuego 
            WHERE alias = $alias
        */
        $valoraciones = Valoracion::select('valoracion.id', 'valoracion.idjuego', 'usuario.alias', 'juego.titulo',
                                         'valoracion', 'juego.caratula', 'usuario.alias')
            ->join('usuario', 'usuario.id', '=', 'valoracion.idusuario')
            ->join('juego', 'juego.id', '=', 'valoracion.idjuego')
            ->where('usuario.alias','=',$alias)
            ->orderby('valoracion.id','DESC')
            ->get();
        
        return response()->json($valoraciones,200);
        //return response()->json(Valoracion::all(),200);
    }
}
