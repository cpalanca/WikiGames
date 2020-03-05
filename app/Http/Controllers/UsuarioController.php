<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Carbon\Carbon;
use Mail;
use App\Mail\RecoveryPassUser;
use Illuminate\Support\Facades\DB;
use App\Usuario;

class UsuarioController extends Controller
{
    // metodo get
    public function index()
    {
        return response()->json(Usuario::all(),200);
    }
   /* public function create()
    {
        return response()->json(['mensaje' => 'create'], 200);
    }*/
    public function store(Request $request)
    {
        try{
        $opciones = [
            'cost' => 11,
        ];
        $clave = password_hash($request->password, PASSWORD_BCRYPT, $opciones);
        $request->merge([ 'password' => $clave ]);
        $usuario = Usuario::create($request->all());
        } catch(\Exception $e){
            return response()->json(false, 400);
        }
        return response()->json(true, 201);
    }
    public function show($id)
    {
        $usuario = Usuario::find($id);
        return response()->json(['data' => $usuario], 200);
    }
   /* public function edit($id)
    {
        return response()->json(['mensaje' => 'edit'], 200);
    }*/
    
    public function update(Request $request, $id){
        $usuario = Usuario::find($id);
        $array = ['error' => 'data not deleted'];
        $status = 400;
        
        if($usuario != null){
            try{
                $result = $usuario->update($request->all());
                $array = ['data' => $result];
                $status = 200;
            }catch(\Exception $e){
                
            }
            return response()->json($array, $status);
        }    
        
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
    
    public function destroy($id){
        $result = Usuario::destroy($id);
        if($result){
            return response()->json([], 204);
        }
        return response()->json(['error' => 'data not deleted'], 400);
    }
    
    public function correctPass($alias, $password){
        try{
            $usuario = Usuario::where('alias', $alias)->first();
            if(password_verify($password, $usuario->password)){
                return response()->json(true, 200);
            }else{
                return response()->json(false, 200);
            }
        }catch(\Exception $e){
            return response()->json(false, 200);
        }
    }

    public function getInfoUsuario($alias){
        $usuario = Usuario::where('alias', $alias)->first();
        if($usuario !== null){
            return response()->json($usuario, 200);
        }
        return response()->json(false, 200);
    }
    
    
    public function resetPassword(Request $request)
    {
        // guia interpretada NO ESTA IGUAL: 
        //https://medium.com/@victorighalo/custom-password-reset-in-laravel-21e57816989f
       //validamos si existe el usuario
        $user = DB::table('usuario')->where('correo', '=', $request->email)->first();
        //sino existe devuelvo false
        if(!$user){
             return response()->json(false, 200);
        }else{
                //Creo un Password Reset Token
            DB::table('password_resets')->insert([
                'email' => $request->email,
                'token' => Str::random(60),
                'created_at' => Carbon::now()
            ]);
            
            //Recojemos el token creado
            $tokenData = DB::table('password_resets')->where('email', $request->email)->first();
            //Enviamos el token por email.
            $this->sendResetEmail($request->email, $tokenData->token);
            return response()->json(true, 200);
        }
        
    }

    private function sendResetEmail($email, $token)
    {
        //Recojemos los datos del usuario para saber su alias y llamarlo por su nombre en su email personalizado
        $user = DB::table('usuario')->where('correo', $email)->select('alias','correo')->first();
        //Generamos el link para resetear la contraseña y lo insertamos en un link.
        $link = config('base_url') . 'password/reset/' . $token . '?correo=' . urlencode($user->correo);
        $data = array("link" => $link, "alias" => $user->alias, "correo" => $user->correo);
        //url('../wp/password/reset')
        //MANDAMOS EL EMAIL
        Mail::to($user->correo)->send(new RecoveryPassUser($data));
    }

}
