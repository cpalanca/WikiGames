//
//  ViewController.swift
//  wikiGames
//
//  Created by Carlos Palanca Giménez on 04/02/2020.
//  Copyright © 2020 Carlos Palanca Giménez. All rights reserved.
//

import UIKit

class LoginController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tfAlias: CTextField! {
        didSet {
              tfAlias.tintColor = UIColor.white
              tfAlias.setIcon(#imageLiteral(resourceName: "icon-user"))
           }
        }
    
    @IBOutlet weak var tfPassword: CTextField! {
    didSet {
          tfPassword.tintColor = UIColor.white
          tfPassword.setIcon(#imageLiteral(resourceName: "icon-password"))
       }
    }
    
    @IBAction func btLogin(_ sender: UIButton) {
        if (tfPassword.text?.isEmpty == true || tfAlias.text?.isEmpty == true) {
            let alert = UIAlertController(title: "Error", message: "Compruebe que los campos han sido rellenados.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Continuar", style: .default, handler: nil))
            self.present(alert, animated: true)
        }else{
            var alias = tfAlias.text
            var pass = tfPassword.text
            doLogin(alias, pass)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
   
    override func viewDidAppear(_ animated: Bool) {
        let preferences = UserDefaults.standard
        let name = "alias"
        if preferences.object(forKey: name) == nil {
        } else {
            DispatchQueue.main.async {
                self.getIdUser("\(preferences.object(forKey: name)!)")
                self.performSegue(withIdentifier: "showGamesList", sender: UIButton.self)
            }
        }
    }
    
    func getIdUser(_ alias:String){
        if alias != nil {
            var ok = HttpClient.get("getinfousuario/\(alias)") { (data, response, error) in
                guard let data = data else{
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let resultado = try decoder.decode(Usuario.self, from: data)
                    if (resultado != nil){
                        let idusuario = resultado.id
                        DispatchQueue.main.async {
                            let preferences = UserDefaults.standard
                            let key = "idusuario"
                            preferences.set(idusuario, forKey: key)
                        }
                    }else{
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true)
                            let alert = UIAlertController(title: "Error", message: "Problema al obtener el usuario.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "De acuerdo", style: .default, handler: nil))
                            self.present(alert, animated: true)
                        }
                    }
                } catch let parsingError {
                    print("Error", parsingError)
                }
            }
        }else{
            dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
            let alert = UIAlertController(title: "Error", message: "Se ha producido un error al intentar obtener tu usuario.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Anterior", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    func doLogin(_ alias: String?, _ pass: String?){
        var ok = HttpClient.get("usuario/\(alias!)/\(pass!)") { (data) in
            guard let data = data else{
                return
            }
            do {
                let decoder = JSONDecoder()
                let resultado = try decoder.decode(Bool.self, from: data)
                print("El resultado es: \(resultado)")
                if (resultado){
                    //Crear shared preferences
                    let preferences = UserDefaults.standard
                    let value = alias!
                    let name = "alias"
                    preferences.set(value, forKey: name)
                    self.getIdUser(value)
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "showGamesList", sender: UIButton.self)
                    }
                }else{
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Error", message: "Usuario o contraseña incorrectos.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "De acuerdo", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                }
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

