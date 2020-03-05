//
//  EditJuegoViewController.swift
//  wikiGames
//
//  Created by Carlos Palanca Giménez on 13/02/2020.
//  Copyright © 2020 Carlos Palanca Giménez. All rights reserved.
//

/*pasar datepicker a string
https://www.youtube.com/watch?v=3IHsV-IoONg*/

import UIKit

class EditJuegoViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBAction func editarFoto(_ sender: UITapGestureRecognizer) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    var dataimagen:Any?
    
    @IBOutlet weak var tfFecha: UITextField!
    @IBOutlet weak var ivImagen: UIImageView!
    @IBOutlet weak var tfTitulo: UITextField!
    @IBOutlet weak var tfDescription: UITextView!
    @IBOutlet weak var tfTipo: UITextField!
    @IBOutlet weak var btSaveEdition: UIButton!
    
    var juego:Juego?
    var idjuego:String?
    
    @IBAction func btEditar(_ sender: UIButton) {
        if(tfTitulo.text?.isEmpty == true || tfTipo.text?.isEmpty == true || tfDescription.text?.isEmpty == true || tfFecha.text?.isEmpty == true){
            let alert = UIAlertController(title: "Error", message: "Rellene todos los campos del formulario para realizar la edición.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Continuar", style: .default, handler: nil))
            self.present(alert, animated: true)
        }else{
            let titulo:String = tfTitulo.text!
            let tipo:String = tfTipo.text!
            let descripcion:String = tfDescription.text
            let caratula = self.juego?.caratula
            let id:String = self.idjuego!
            var textofecha = tfFecha.text
            self.btSaveEdition.isEnabled = false
            doEditGame(id, titulo, caratula, tipo, textofecha, descripcion)
        }
    }
    
    func doEditGame(_ id:String?, _ titulo: String?,_ caratula: String?,_ tipo: String?,_ textofecha:String? ,_ descripcion: String?){
        var contenido: [String: Any] = [
            "titulo": titulo!,
            "caratula": caratula!,
            "tipo": tipo!,
            "flanzamiento": textofecha!,
            "descripcion": descripcion!
        ]

        var ok = HttpClient.put("juego/"+id!, contenido) { (data) in
            guard let data = data else{
                return
            }
            do {
                let decoder = JSONDecoder()
                let resultado = try decoder.decode(Bool.self, from: data)
                if (resultado){
                    DispatchQueue.main.async {
                        self.subirimage()
                        self.navigationController?.popViewController(animated: true)
                    }
                }else{
                    self.btSaveEdition.isEnabled = true
                    DispatchQueue.main.async {
                        self.navigationController?.popToRootViewController(animated: true)
                        let alert = UIAlertController(title: "Error", message: "No se ha podido editar el juego.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Continuar", style: .default, handler: nil))
                        self.present(alert, animated: true)
                        
                    }
                }
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillTheCard()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        //Descomentar, si el tap no debe interferir o cancelar otras acciones
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        tfFecha.delegate = self
    }
    
    @objc func dismissKeyboard() {
        //Las vistas y toda la jerarquía renuncia a responder, para esconder el teclado
        view.endEditing(true)
    }
    
    func fillTheCard(){
        let preferences = UserDefaults.standard
        let name = "idjuego"
        let id = preferences.object(forKey: name)!
        self.idjuego = "\(id)"
        if preferences.object(forKey: name) != nil {
            var ok = HttpClient.get("juego/\(id)") { (data, response, error) in
                guard let data = data else{
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let resultado = try decoder.decode(Juego.self, from: data)
                    if (resultado != nil){
                        let urlImagen = Routes.uploads + resultado.caratula
                        if let url = URL(string: urlImagen) {
                            let cola = DispatchQueue(label: "poner.imagen", qos: .default, attributes: .concurrent)
                            cola.async {
                                if let data = try? Data(contentsOf: url), let imagen = UIImage(data: data) {
                                    DispatchQueue.main.async {
                                        self.ivImagen.image = imagen
                                        self.tfTipo.text = resultado.tipo
                                        self.tfDescription.text = resultado.descripcion
                                        self.tfTitulo.text = resultado.titulo
                                        self.juego = resultado
                                        self.tfFecha.text = resultado.flanzamiento
                                    }
                                }
                            }
                        }
                    }else{
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true)
                            let alert = UIAlertController(title: "Error", message: "Problema al cargar el juego.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "De acuerdo", style: .default, handler: nil))
                            self.present(alert, animated: true)
                        }
                    }
                } catch let parsingError {
                    print("Error", parsingError)
                }
            }
        }else{
            self.navigationController?.popViewController(animated: true)
            let alert = UIAlertController(title: "Error", message: "Se ha producido un error al cargar la edición del juego.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Anterior", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        self.dataimagen = selectedImage.jpegData(compressionQuality: 0.1)
        
        var data = selectedImage.jpegData(compressionQuality: 0.1)
        self.ivImagen.image = selectedImage
        
        dismiss(animated: true, completion: nil)
    }
    
    func subirimage(){
        if(self.dataimagen != nil){
            let _ = HttpClient.upload(route: "uploads", fileName: self.juego!.caratula, fileParameter: "file", fileData: self.dataimagen! as! Data) { (data) in
                print(data!)
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension EditJuegoViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.openDatePicker()
    }
}

extension EditJuegoViewController{
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
