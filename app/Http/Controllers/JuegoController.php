<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Juego;

class JuegoController extends Controller
{
    // metodo get
    public function index()
    {
        /*
            SELECT juego.id, valoracion.idjuego, titulo, tipo, caratula, flanzamiento, descripcion, 
            CAST(COALESCE(AVG(valoracion.valoracion),0) AS DECIMAL (4,2)) as 'Valoracion'
            FROM valoracion RIGHT JOIN juego ON juego.id = valoracion.idjuego
            GROUP BY id;
        */
        $juegos = Juego::select('juego.*', DB::raw('cast(coalesce(avg(valoracion.valoracion), 0)as decimal (4,2)) AS media'))
            ->leftJoin('valoracion', 'juego.id', '=', 'valoracion.idjuego', 'left outer')
            ->groupBy('juego.id')
            ->get();
        
        return response()->json($juegos,200);
        //return response()->json(Juego::all(),200);
    }
   /* public function create()
    {
        return response()->json(['mensaje' => 'create'], 200);
    }*/
    public function store(Request $request)
    {
        try{
        $juego = Juego::create($request->all());
        } catch(\Exception $e){
            return response()->json(['error' => $e->getMessage()], 400);
        }
        return response()->json(true, 201);
    }
    public function show($id)
    {
        /*
            SELECT juego.id, valoracion.idjuego, titulo, tipo, caratula, flanzamiento, descripcion, 
            CAST(COALESCE(AVG(valoracion.valoracion),0) AS DECIMAL (4,2)) as 'Valoracion'
            FROM valoracion RIGHT JOIN juego ON juego.id = valoracion.idjuego
            WHERE juego.id = $id
            GROUP BY id;
        */
        $juego = Juego::select('juego.*', DB::raw('cast(coalesce(avg(valoracion.valoracion), 0)as decimal (4,2)) AS media'))
            ->leftJoin('valoracion', 'juego.id', '=', 'valoracion.idjuego', 'left outer')
            ->where('juego.id',$id)
            ->groupBy('juego.id')
            ->get();
        
        return response()->json($juego[0],200);
        /*$juego = Juego::find($id);
        return response()->json($juego, 200);*/
    }
   /* public function edit($id)
    {
        return response()->json(['mensaje' => 'edit'], 200);
    }*/
    public function update(Request $request, $id)
    {
        $juego = Juego::find($id);
        $status = 400;
        
        if($juego != null){
            try{
                $result = $juego->update($request->all());
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
        $result = Juego::destroy($id);
        if($result){
            return response()->json([], 204);
        }
        return response()->json(['error' => 'data not deleted'], 400);
    }
    
    public function upload(Request $request)
    {
        if($request->hasFile('file') && $request->file('file')->isValid()) {
            $file = $request->file('file');
            $target = 'uploads/';
            $name = $file->getClientOriginalName();
            $file->move($target, $name);
            return 'image uploaded';
        }
        return 'error uploading image';
    }
    
    public function juegosInteractuados($alias){
        /*
            SELECT juego.titulo, juego.caratula
            FROM juego
            LEFT JOIN valoracion ON juego.id = valoracion.idjuego
            LEFT JOIN comentario ON juego.id = comentario.idjuego
            RIGHT JOIN usuario ON usuario.id = comentario.idusuario OR usuario.id = valoracion.idusuario
            WHERE usuario.alias = 'alias'
            GROUP BY juego.id
        */
        $juegos = DB::table("juego")
            ->select('juego.id','titulo','caratula','tipo','descripcion','flanzamiento')
            ->leftJoin('valoracion', 'juego.id', '=', 'valoracion.idjuego', 'left outer')
            ->leftJoin('comentario', 'juego.id', '=', 'comentario.idjuego', 'left outer')
            ->rightJoin('usuario', function($join){
                $join->on('usuario.id','=','valoracion.idusuario');
                $join->orOn('usuario.id','=','comentario.idusuario');
            })
            ->groupBy('juego.id')
            ->where('usuario.alias',$alias)
            ->get();
            
            
        return response()->json($juegos,200);
    }
    
}
