//
//  AddCommentViewController.swift
//  wikiGames
//
//  Created by DAW on 20/02/2020.
//  Copyright © 2020 Carlos Palanca Giménez. All rights reserved.
//

import UIKit
//en los errores hacer dismiss de la pantalla
class AddCommentViewController: UIViewController {
    
    var idusuario:String?
    var idjuego:String?
    var frameView: UIView!

    @IBOutlet weak var lbTitulo: UILabel!
    @IBAction func btAddComment(_ sender: UIButton) {
        if(tvComentario.text.isEmpty == true){
            let alert = UIAlertController(title: "Error", message: "Su comentario está vacío.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "De acuerdo", style: .default, handler: nil))
            self.present(alert, animated: true)
        }else{
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let fecha = formatter.string(from: date)

            addComment("\(fecha)")
        }
    }
    @IBOutlet weak var tvComentario: UITextView!
    @IBOutlet weak var ivImagen: UIImageView!
    @IBAction func btCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func addComment(_ fecha:String){
        if fecha != nil {
            var contenido: [String: Any] = [
                "idusuario": self.idusuario,
                "idjuego": self.idjuego,
                "fecha": fecha,
                "comentario": self.tvComentario.text
            ]
            var ok = HttpClient.post("comentario", contenido) { (data) in
                guard let data = data else{
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let resultado = try decoder.decode(Bool.self, from: data)
                    if (resultado){
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }else{
                        //self.btCreation.isEnabled = true
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Error", message: "No se ha podido añadir el comentario.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Continuar", style: .default, handler: nil))
                            self.present(alert, animated: true)
                        }
                    }
                } catch let parsingError {
                    print("Error", parsingError)
                }
            }
        }else{
            self.navigationController?.popViewController(animated: true)
            let alert = UIAlertController(title: "Error", message: "Error al tratar de obtener la fecha de hoy.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Salir", style: .default, handler: nil))
            self.present(alert, animated: true)
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
                        self.idusuario = "\(idusuario)"
                        DispatchQueue.main.async {
                            let preferences = UserDefaults.standard
                            let name = "idjuego"
                            let idjuego = preferences.object(forKey: name)!
                            self.idjuego = "\(idjuego)"
                            self.getGameInfo("\(idjuego)")
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
                    self.dismiss(animated: true, completion: nil)
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
    
    func getGameInfo(_ idjuego:String){
        if idjuego != nil {
            var ok = HttpClient.get("juego/\(idjuego)") { (data, response, error) in
                guard let data = data else{
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let resultado = try decoder.decode(Juego.self, from: data)
                    if (resultado != nil){
                        DispatchQueue.main.async {
                            //coger el id y la imágen del juego
                            let urlImagen = Routes.uploads + resultado.caratula
                            if let url = URL(string: urlImagen) {
                                let cola = DispatchQueue(label: "poner.imagen", qos: .default, attributes: .concurrent)
                                cola.async {
                                    if let data = try? Data(contentsOf: url), let imagen = UIImage(data: data) {
                                        DispatchQueue.main.async {
                                            self.lbTitulo.text = resultado.titulo
                                            self.ivImagen.image = imagen
                                        }
                                    }
                                }
                            }
                        }
                    }else{
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.tintColor = UIColor.white
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        //coger el id del usuario
        let preferences = UserDefaults.standard
        let name = "alias"
        let alias = preferences.object(forKey: name)!
        
        getIdUser("\(alias)")
        
        //mover escena
        // notification center
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notificación:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    //mover escenea
    @objc func keyboardWillShow (notificacion: NSNotification) {
        guard let keyboardSize = (notificacion.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
              // if keyboard size is not available for some reason, dont do anything
              return
           }
         
         // move the root view up by the distance of keyboard height
         self.view.frame.origin.y = 0 - keyboardSize.height
    }
    @objc func keyboardWillHide (notificación: NSNotification) {
        // move back the root view origin to zero
        self.view.frame.origin.y = 0
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
