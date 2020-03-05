//
//  RegisterViewController.swift
//  wikiGames
//
//  Created by DAW on 07/02/2020.
//  Copyright © 2020 Carlos Palanca Giménez. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var tfRepeatPass: UITextField!
    @IBOutlet weak var tfCorreo: UITextField!
    @IBOutlet weak var tfPass: UITextField!
    @IBOutlet weak var tfAlias: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.navigationBar.tintColor = UIColor.white
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Shared preferences lectura
        let preferences = UserDefaults.standard
        let name = "alias"
        if preferences.object(forKey: name) != nil {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "goToGames", sender: UIButton.self)
            }
        }
    }
    
    
    @IBAction func doRegistration(_ sender: UIButton) {
        if (tfPass.text?.isEmpty == true || tfAlias.text?.isEmpty == true || tfCorreo.text?.isEmpty == true || tfRepeatPass.text?.isEmpty == true) {
            let alert = UIAlertController(title: "Error", message: "Rellene todos los campos.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Continuar", style: .default, handler: nil))
            self.present(alert, animated: true)
        }else{
            if (isValidEmail(emailID: tfCorreo.text!) == true) {
                if(tfPass.text != tfRepeatPass.text){
                    let alert = UIAlertController(title: "Error", message: "La contraseña debe ser igual.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Continuar", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }else{
                    self.doTheRegister(tfAlias.text, tfCorreo.text, tfPass.text)
                }
            }else{
                let alert = UIAlertController(title: "Error", message: "Debe introducir un correo válido.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Continuar", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
    
    func isValidEmail(emailID:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        print(emailTest.evaluate(with: emailID))
        return emailTest.evaluate(with: emailID)
    }
    
    func doTheRegister(_ alias: String?, _ correo: String?,_ pass: String?){
        var usuario = Usuario(alias!, correo!, pass!)
        //print(usuario.alias+" "+usuario.correo+" "+usuario.password)
        var contenido: [String: Any] = [
            "alias": usuario.alias,
            "correo": usuario.correo,
            "password": usuario.password,
        ]

        var ok = HttpClient.post("usuario", contenido) { (data) in
            guard let data = data else{
                return
            }
            do {
                let decoder = JSONDecoder()
                let resultado = try decoder.decode(Bool.self, from: data)
                if (resultado){
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "toTheBegin", sender: UIButton.self)
                    }
                }else{
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Error", message: "No se ha podido registrar.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Continuar", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                }
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
    }
    
}
