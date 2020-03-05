<?php

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;

class RecoveryPassUser extends Mailable
{
    use Queueable, SerializesModels;

    public $link;
    public $alias;
    public $correo;

    public function __construct(array $data = array())
    {
        foreach($data as $key => $value) {
            $this->$key = $value;
        }
    }

    public function build()
    {
        return $this->view('mails.recoverypassuser');
    }
}