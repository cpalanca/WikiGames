//
//  AddJuegoViewController.swift
//  wikiGames
//
//  Created by Carlos Palanca Giménez on 13/02/2020.
//  Copyright © 2020 Carlos Palanca Giménez. All rights reserved.
//

import UIKit

class AddJuegoViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var tfFecha: UITextField!
    @IBAction func accionPrueba(_ sender: UITapGestureRecognizer) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    var fotoseleccionada = false
    var caratula:String = ""
    
    @IBOutlet weak var btCreation: UIButton!
    @IBOutlet weak var imCaratula: UIImageView!
    @IBOutlet weak var tfTitulo: UITextField!
    @IBOutlet weak var tfTipo: UITextField!
    @IBOutlet weak var tvDescripcion: UITextView!
    
    @IBAction func btCrear(_ sender: UIButton) {
        print(randomString(length: 40))
        if(fotoseleccionada){
            if(tfTitulo.text?.isEmpty == true || tfTipo.text?.isEmpty == true || tvDescripcion.text?.isEmpty == true || tfFecha.text?.isEmpty == true){
                let alert = UIAlertController(title: "Error", message: "Rellene todos los campos del formulario.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Continuar", style: .default, handler: nil))
                self.present(alert, animated: true)
            }else{
                btCreation.isEnabled = false
                let titulo:String = tfTitulo.text!
                let tipo:String = tfTipo.text!
                let descripcion:String = tvDescripcion.text
                
                var textofecha = tfFecha.text
                
                doAddGame(titulo, self.caratula, tipo, textofecha, descripcion)
            }
        }else{
            let alert = UIAlertController(title: "Error", message: "Debes seleccionar una imágen para poder crear un juego.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Continuar", style: .default, handler: nil))
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
    
        //Descomentar, si el tap no debe interferir o cancelar otras acciones
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        tfFecha.delegate = self
    }
    
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func doAddGame(_ titulo: String?,_ caratula: String?,_ tipo: String?,_ textofecha:String? ,_ descripcion: String?){
        var contenido: [String: Any] = [
            "titulo": titulo,
            "caratula": self.caratula,
            "tipo": tipo,
            "flanzamiento": textofecha,
            "descripcion": descripcion
        ]

        var ok = HttpClient.post("juego", contenido) { (data) in
            guard let data = data else{
                return
            }
            do {
                let decoder = JSONDecoder()
                let resultado = try decoder.decode(Bool.self, from: data)
                if (resultado){
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "backToGameList", sender: UIButton.self)
                    }
                }else{
                    self.btCreation.isEnabled = true
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Error", message: "No se ha podido añadir el juego.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Continuar", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                }
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
    }
    
    //comprobamos que el juego se guarda
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        var data = selectedImage.jpegData(compressionQuality: 0.1)
        self.imCaratula.image = selectedImage
        self.fotoseleccionada = true
        
        if (self.caratula.isEmpty){
            self.caratula = randomString(length: 40) + ".jpg"
        }

        let _ = HttpClient.upload(route: "uploads", fileName: self.caratula, fileParameter: "file", fileData: data!) { (data) in
            print(data!)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        //Las vistas y toda la jerarquía renuncia a responder, para esconder el teclado
        view.endEditing(true)
    }
    
}

extension AddJuegoViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.openDatePicker()
    }
}

extension AddJuegoViewController{
    func openDatePicker(){
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        tfFecha.inputView = datePicker
        
        let toolbar = UIToolbar(frame: CGRect(x:0, y:0, width: self.view.frame.width, height: 44))
        let cancelBt = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(self.cancelBtn))
        let doneBt = UIBarButtonItem(title: "Seleccionar", style: .done, target: self, action: #selector(self.doneBtn))
        let flexibleBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancelBt, flexibleBtn, doneBt], animated: false)
        tfFecha.inputAccessoryView = toolbar
    }
    
    @objc
    func cancelBtn(){
        tfFecha.resignFirstResponder()
    }
    
    @objc
    func doneBtn(){
        if let datePicker = tfFecha.inputView as? UIDatePicker{
            print(datePicker.date)
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            tfFecha.text = dateFormatter.string(from: datePicker.date)
        }
        tfFecha.resignFirstResponder()
    }
}
