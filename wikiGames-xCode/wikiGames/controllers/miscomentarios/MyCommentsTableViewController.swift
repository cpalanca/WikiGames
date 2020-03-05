//
//  MyCommentsTableViewController.swift
//  wikiGames
//
//  Created by Carlos Palanca Giménez on 18/02/2020.
//  Copyright © 2020 Carlos Palanca Giménez. All rights reserved.
//

import UIKit

class MyCommentsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

        @IBOutlet var tableView: UITableView!
        var resultsController = UITableViewController()
        var listComentarios = [Comentario]()
        var comentarioListo:Comentario?
        
        override func viewDidLoad() {
            super.viewDidLoad()
        }
        
            
        override func viewDidAppear(_ animated: Bool) {
            self.tableSettings()
            fillListComments()
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
    
        
        func fillListComments(){
            let preferences = UserDefaults.standard
            let name = "alias"
            // RUTA DE COMENTARIOS PASANDO ALIAS
            //comentario/comentariosusuario/{alias}
            var ok = HttpClient.get("comentario/comentariosusuario/\(preferences.object(forKey: name)!)") { (data) in
                guard let data = data else{
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    self.listComentarios = try decoder.decode([Comentario].self, from: data)
                    if (self.listComentarios == nil){
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Atención", message: "Todavía no has añadido ningún comentario.", preferredStyle: .alert)
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
                //print(listComentarios.count)
                return listComentarios.count
            }
            
            func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "commentarioCell", for: indexPath) as! ListCommentsTableViewCell
                    cell.labelTitulo.text = self.listComentarios[indexPath.row].titulo
                    cell.labelComentario.text = self.listComentarios[indexPath.row].comentario
                    let urlImagen = Routes.uploads + self.listComentarios[indexPath.row].caratula
                    if let url = URL(string: urlImagen) {
                        let cola = DispatchQueue(label: "poner.imagen", qos: .default, attributes: .concurrent)
                        cola.async {
                            if let data = try? Data(contentsOf: url), let imagen = UIImage(data: data) {
                                DispatchQueue.main.async {
                                    cell.ivCaratula.image = imagen
                                }
                            }
                        }
                    }

                return cell
            }
            
            func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                comentarioListo = self.listComentarios[indexPath.row]
                performSegue(withIdentifier: "goToSingleComment", sender: comentarioListo)
            }
            

            //CON NAVIGATION

        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "goToSingleComment" {
                let DestViewController = segue.destination as! UINavigationController
                let targetController = DestViewController.topViewController as! CommentViewController
                targetController.comentario = comentarioListo
                //Guardar en shared el idComentario
                let preferences = UserDefaults.standard
                let value = comentarioListo!.id
                let name = "idComentario"
                preferences.set(value, forKey: name)
            }
        }
    
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                var idComentario = self.listComentarios[indexPath.row].id
                var okc = HttpClient.delete("comentario/\(idComentario)") { (data) in
                    DispatchQueue.main.async {
                        self.listComentarios.remove(at: indexPath.row)
                        self.tableView.deleteRows(at: [indexPath], with: .fade)                        }
                }
            }
        }

            // CON TABBARVIEWCONTROLLER
            //https://stackoverflow.com/questions/29572744/prepare-for-segue-to-uitabbarcontroller-tab
        }
