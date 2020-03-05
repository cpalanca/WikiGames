//
//  SingleViewController.swift
//  wikiGames
//
//  Created by dam on 12/02/2020.
//  Copyright © 2020 Carlos Palanca Giménez. All rights reserved.
//

import UIKit

class SingleViewController: UIViewController{
    
    @IBOutlet weak var titleJuego: UILabel!
    @IBOutlet weak var imgJuego: UIImageView!
    @IBOutlet weak var descriptionJuego: UITextView!
    @IBOutlet weak var categoryJuego: UILabel!
    @IBOutlet weak var ratingAverage: UILabel!
    @IBOutlet weak var ratingUser: SelectRatingView!
    @IBOutlet weak var ratinUserValue: UILabel!
    var listValoraciones = [Valoracion]()
    var juego:Juego?
    var idjuego:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.descriptionJuego.isEditable = false
        let preferences = UserDefaults.standard
        let name = "idjuego"
        if preferences.object(forKey: name) == nil {
            dismiss(animated: true, completion: nil)
            let alert = UIAlertController(title: "Error", message: "Juego no encontrado.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "De acuerdo", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        self.idjuego = "\(preferences.object(forKey: name)!)"
        fillTheCard()
        ratingUser.delegate = self
        ratingUser.contentMode = UIView.ContentMode.scaleAspectFit
        ratingUser.type = .floatRatings
        
        self.navigationController!.navigationBar.tintColor = UIColor.white
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
    }
    
    func fillTheCard(){
        //rellenar el juego de la variable distancia con una llamada
        var ok = HttpClient.get("juego/\(self.idjuego!)") { (data) in
            guard let data = data else{
                return
            }
            do {
                let decoder = JSONDecoder()
                self.juego = try decoder.decode(Juego.self, from: data)
                if (self.juego == nil){
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                        let alert = UIAlertController(title: "Error", message: "No se ha encontrado el juego.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Continuar", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                }else{
                    let urlImagen = Routes.uploads + self.juego!.caratula
                    if let url = URL(string: urlImagen) {
                        let cola = DispatchQueue(label: "poner.imagen", qos: .default, attributes: .concurrent)
                        cola.async {
                            if let data = try? Data(contentsOf: url), let imagen = UIImage(data: data) {
                                DispatchQueue.main.async {
                                    self.imgJuego.image = imagen
                                }
                            }
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.titleJuego.text = "\(self.juego!.titulo)"
                        
                        self.descriptionJuego.text = self.juego!.descripcion
                        self.categoryJuego.text = self.juego!.tipo
                        self.ratingAverage.text = self.juego!.media
                        self.requestUserRating()
                    }
                }
            }catch let parsingError {
                print("Error", parsingError)
            }
        }
    }
    
    func requestUserRating(){
        let preferences = UserDefaults.standard
        let name = "alias"
        // RUTA DE VALORACIONES PASANDO ALIAS
        var ok = HttpClient.get("valoracion/valoracionesusuario/\(preferences.object(forKey: name)!)") { (data) in
            guard let data = data else{
                return
            }
            do {
                let decoder = JSONDecoder()
                self.listValoraciones = try decoder.decode([Valoracion].self, from: data)
                if (self.listValoraciones.count > 0){
                    DispatchQueue.main.async {
                        for valoracion in self.listValoraciones {
                            if(valoracion.idjuego == self.juego!.id){
                                print("valoracion.idjuego :\(valoracion.idjuego)")
                                print("juego!.id:\(self.juego!.id)")
                                let rate = Double(valoracion.valoracion)
                                self.ratinUserValue.text = "\(rate!)"
                                self.ratingUser.rating = rate!/2.0
                                self.ratingUser.isUserInteractionEnabled = false
                            }
                        }
                    }
                }
            }catch let parsingError {
                print("Error", parsingError)
            }
            
        }
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
   /* override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("entra")
        if let anterior = segue.destination as? ListGameViewController{
            self.juego = anterior.juego
            print(self.juego)
        }
    }
*/
    func doUserValoracion(_ valoracion: String?){
        let preferences = UserDefaults.standard
        let idusuario = preferences.object(forKey: "idusuario")

        var contenido: [String: Any] = [
            "idusuario": idusuario!,
            "idjuego": String(juego!.id),
            "valoracion": valoracion!
        ]
        
        var ok = HttpClient.post("valoracion", contenido) { (data) in
            guard let data = data else{
                return
            }
            do {
                let decoder = JSONDecoder()
                let resultado = try decoder.decode(Bool.self, from: data)
                if (resultado){
                    DispatchQueue.main.async {
                        self.ratingUser.isUserInteractionEnabled = false
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Valoración insertada", message: "Se ha realizado correctamente", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "De acuerdo", style: .default, handler: nil))
                            self.present(alert, animated: true)
                            self.fillTheCard()
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Error", message: "Puede modificar su valoración en su perfil.", preferredStyle: .alert)
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

extension SingleViewController: SelectRatingViewDelegate {
    // MARK: SelectRatingViewDelegate
    func selectRatingView(_ ratingView: SelectRatingView, isUpdating rating: Double) {
        self.ratinUserValue.text = String(format: "%.2f", self.ratingUser.rating*2)
    }
    
    func selectRatingView(_ ratingView: SelectRatingView, didUpdate rating: Double) {
       self.ratinUserValue.text = String(format: "%.2f", self.ratingUser.rating*2)
        doUserValoracion(String(format: "%.2f", self.ratingUser.rating*2))
    }
}
