<?php 
class Juego {
    protected $titulo;
    protected $caratula;
    protected $tipo;
    protected $flanzamiento;
    protected $descripcion;



    function __construct($data) {
        foreach ($data as $clave => $valor){
            if (property_exists($this,$clave)) {
                $this->$clave = $valor;
            }
        }
    }

    
    
    public function getValues() { 
        $fields = array();
        $fields[] = 'null';
        foreach ($this as $clave => $valor){
                $fields[] = "'".$valor."'";
        }
        return $fields;

    }


} 
?> 