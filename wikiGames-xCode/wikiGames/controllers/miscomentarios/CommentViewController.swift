//
//  CommentViewController.swift
//  wikiGames
//
//  Created by Carlos Palanca Giménez on 14/02/2020.
//  Copyright © 2020 Carlos Palanca Giménez. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate {
    // MARK: Outlets
    @IBOutlet weak var comentarioImage: UIImageView!
    @IBOutlet weak var tfComment: UITextView!
    @IBOutlet weak var buttonSave: UIBarButtonItem!
    var comentario:Comentario?
    var idComentario:String?
    
    @IBAction func btEditComment(_ sender: UIBarButtonItem) {
        if(tfComment.text.isEmpty == true){
            let alert = UIAlertController(title: "Error", message: "No se pueden publicar comentarios vacíos.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "De acuerdo", style: .default, handler: nil))
            self.present(alert, animated: true)
        }else{
            doEditComment("\(self.idComentario!)", self.tfComment.text)
        }
    }
    
    func doEditComment(_ id:String?, _ comentario: String?){
        print("\(id!)")
        print("\(comentario!)")
        var contenido: [String: Any] = [
            "comentario": comentario!
        ]

        var ok = HttpClient.put("comentario/"+id!, contenido) { (data) in
            guard let data = data else{
                return
            }
            do {
                let decoder = JSONDecoder()
                let resultado = try decoder.decode(Bool.self, from: data)
                if (resultado){
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        self.navigationController?.popToRootViewController(animated: true)
                        let alert = UIAlertController(title: "Error", message: "No se ha podido editar el comentario.", preferredStyle: .alert)
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
        updateSaveButtonState()
        
        /*let preferences = UserDefaults.standard
        let name = "idusuario"
        print("\(preferences.object(forKey: name)!)")*/
        
        let preferences = UserDefaults.standard
        let name = "idComentario"
        
        self.idComentario = "\(preferences.object(forKey: name)!)"
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        //Descomentar, si el tap no debe interferir o cancelar otras acciones
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        //mover escena
        // notification center
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notificación:)), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        fillTheCard()
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
        //Las vistas y toda la jerarquía renuncia a responder, para esconder el teclado
        view.endEditing(true)
    }
    
    func fillTheCard(){
        let urlImagen = Routes.uploads + comentario!.caratula
        if let url = URL(string: urlImagen) {
            let cola = DispatchQueue(label: "poner.imagen", qos: .default, attributes: .concurrent)
            cola.async {
                if let data = try? Data(contentsOf: url), let imagen = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.comentarioImage.image = imagen
                    }
                }
            }
        }
        self.tfComment.text = comentario!.comentario
    }
    
       // MARK: TextFieldDelegate
        func textFieldDidBeginEditing(_ textField: UITextField) {
            // Disable the Save button while editing.
            //buttonSave.isEnabled = false
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            return true
        }
        func textFieldDidEndEditing(_ textField: UITextField) {
            updateSaveButtonState()
            navigationItem.title = textField.text
        }
                
        // MARK: Actions
        @IBAction func cancel(_ sender: Any) {
            let isPresentingInAddMealMode = presentingViewController is UINavigationController
            
            if isPresentingInAddMealMode {
                dismiss(animated: true, completion: nil)
            }
            else if let owningNavigationController = navigationController{
                owningNavigationController.popViewController(animated: true)
            }
            else {
                fatalError("The ValoracionViewController is not inside a navigation controller.")
            }
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            super.prepare(for: segue, sender: sender)
            if let button = sender as? UIBarButtonItem, button === buttonSave {
                //comentario = Comentario(name: "" ?? "", image: comentarioImage?.image)
            }
        }
        
        //MARK: Private Methods
        private func updateSaveButtonState() {
            // Disable the Save button if the text field is empty.
            let text = "" ?? ""
            //buttonSave.isEnabled = !text.isEmpty
        }
    }
