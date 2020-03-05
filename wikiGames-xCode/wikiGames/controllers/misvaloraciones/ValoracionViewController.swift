//
//  ValoracionViewController.swift
//
//
//  Created by Carlospalanca on 20/01/2020.
//  Copyright © 2020 Carlospalanca. All rights reserved.
//

import UIKit

class ValoracionViewController: UIViewController {
   // MARK: Outlets
    @IBOutlet weak var valoracionImage: UIImageView!
    @IBOutlet weak var ratingEditGame: SelectRatingView!
    @IBOutlet weak var tituloJuego: UILabel!
    @IBOutlet weak var userRatingValue: UILabel!
    var valoracion:Valoracion?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillTheCard()
        ratingEditGame.delegate = self
        ratingEditGame.contentMode = UIView.ContentMode.scaleAspectFit
        ratingEditGame.type = .floatRatings
        userRatingValue.text = String(format: "%.2f", self.ratingEditGame.rating*2)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.navigationBar.tintColor = UIColor.black
        self.navigationController!.navigationBar.shadowImage = UIImage()
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    func fillTheCard(){
        
        let urlImagen = Routes.uploads + valoracion!.caratula
        if let url = URL(string: urlImagen) {
            let cola = DispatchQueue(label: "poner.imagen", qos: .default, attributes: .concurrent)
            cola.async {
                if let data = try? Data(contentsOf: url), let imagen = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.valoracionImage.image = imagen
                    }
                }
            }
        }
        self.userRatingValue.text = valoracion!.valoracion
        self.tituloJuego.text = valoracion!.titulo
        self.ratingEditGame.rating = Double(valoracion!.valoracion)!/2
    }
    

    // MARK: - Navigation
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func doEditValoracion(_ id:String?,_ valoracion: String?){
        var contenido: [String: Any] = [
            "valoracion": valoracion!
        ]
       // print(valoracion!)
        var ok = HttpClient.put("valoracion/\(id!)", contenido) { (data) in
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
                            let alert = UIAlertController(title: "Valoración actualizada", message: "Se ha realizado correctamente", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "De acuerdo", style: .default, handler: nil))
                            self.present(alert, animated: true)
                        }
                    }
                }else{
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

}

extension ValoracionViewController: SelectRatingViewDelegate {

    // MARK: SelectRatingViewDelegate
    
    func selectRatingView(_ ratingView: SelectRatingView, isUpdating rating: Double) {
        self.userRatingValue.text = String(format: "%.2f", self.ratingEditGame.rating*2)
    }
    
    func selectRatingView(_ ratingView: SelectRatingView, didUpdate rating: Double) {
        doEditValoracion("\(valoracion!.id)", String(format: "%.2f", self.ratingEditGame.rating*2))
       self.userRatingValue.text = String(format: "%.2f", self.ratingEditGame.rating*2)
        
        
    }
    
}
