//
//  RatingTableViewController.swift
//
//  Created by Carlos Palanca on 17/02/2020.
//  Copyright © 2020 Carlos Palanca. All rights reserved.
//

import UIKit

class RatingTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView : UITableView!
    var resultsController = UITableViewController()
    var listValoraciones = [Valoracion]()
    var valoracionLista:Valoracion?
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
        
    override func viewDidAppear(_ animated: Bool) {
        self.tableSettings()
        fillListRating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
          //https://www.tutorialspoint.com/how-to-create-transparent-status-bar-and-navigation-bar-in-ios
        self.navigationController!.navigationBar.tintColor = UIColor.black
        self.navigationController!.navigationBar.isTranslucent = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Restore the navigation bar to default
        navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController!.navigationBar.isTranslucent = true
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    
    func fillListRating(){
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
                if (self.listValoraciones == nil){
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Atención", message: "Todavía no hay ningúna valoracion.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Continuar", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                }
            }catch let parsingError {
                print("Error", parsingError)
            }
            self.do_table_refresh();
        }
    }
    
    func do_table_refresh(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
            return
        }
    }
    
    func tableSettings() {
       self.resultsController.tableView.dataSource = self
       self.resultsController.tableView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            //print(listValoraciones.count)
            return listValoraciones.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "ratingCell", for: indexPath) as! ListRatingTableViewCell
                cell.tituloJuego.text = self.listValoraciones[indexPath.row].titulo
                cell.floatRatingView.rating = Double(self.listValoraciones[indexPath.row].valoracion)!/2
                //print(cell.floatRatingView.rating)
                let urlImagen = Routes.uploads + self.listValoraciones[indexPath.row].caratula
                if let url = URL(string: urlImagen) {
                    let cola = DispatchQueue(label: "poner.imagen", qos: .default, attributes: .concurrent)
                    cola.async {
                        if let data = try? Data(contentsOf: url), let imagen = UIImage(data: data) {
                            DispatchQueue.main.async {
                                cell.ivJuego.image = imagen
                            }
                        }
                    }
                }

            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            valoracionLista = self.listValoraciones[indexPath.row]
            performSegue(withIdentifier: "goToSingleValoracion", sender: valoracionLista)
        }
        
        //https://medium.com/infancyit/traveling-through-the-app-the-segue-magic-part-1-a8091e863164
        // SIN NAVIGATION
    /*
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "goToSingleValoracion" {
                 let vc = segue.destination as! ValoracionViewController
                 vc.valoracion = valoracionLista
                //print(valoracionLista?.caratula)
            }
        }
    */
        
    //https://stackoverflow.com/questions/19774583/setting-a-property-in-a-segue-with-navigation-controller-containing-another-view
        //CON NAVIGATION
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "goToSingleValoracion" {
                let DestViewController = segue.destination as! UINavigationController
                let targetController = DestViewController.topViewController as! ValoracionViewController
                targetController.valoracion = valoracionLista
            }
        }
    
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                var idValoracion = self.listValoraciones[indexPath.row].id
                var okc = HttpClient.delete("valoracion/\(idValoracion)") { (data) in
                    DispatchQueue.main.async {
                        self.listValoraciones.remove(at: indexPath.row)
                        self.tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }
            }
        }
    
        // CON TABBARVIEWCONTROLLER
        //https://stackoverflow.com/questions/29572744/prepare-for-segue-to-uitabbarcontroller-tab
    }
