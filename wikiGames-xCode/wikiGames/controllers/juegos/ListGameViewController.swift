//
//  ListGameViewController.swift
//  wikiGames
//
//  Created by DAW on 10/02/2020.
//  Copyright © 2020 Carlos Palanca Giménez. All rights reserved.
//https://stackoverflow.com/questions/45361454/swift-3-ios-uiview-not-updating-after-retrieving-remote-json-data

import UIKit

class ListGameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating  {

    @IBOutlet weak var tableView : UITableView!
    var searchController : UISearchController!
    var resultsController = UITableViewController()
    
    @IBAction func btGoProfile(_ sender: Any) {
        self.performSegue(withIdentifier: "goProfile", sender: UIButton.self)
    }
    
    var listjuegos = [Juego]()
    var filteredGames = [Juego]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar()
        NotificationCenter.default.addObserver(self, selector: #selector(load), name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    @objc func load(notification: NSNotification){
        fillListGames()
    }

    override func viewDidAppear(_ animated: Bool) {
        self.tableSettings()
        fillListGames()
    }

    func fillListGames(){
        var ok = HttpClient.get("juego/") { (data) in
            guard let data = data else{
                return
            }
            do {
                let decoder = JSONDecoder()
                self.listjuegos = try decoder.decode([Juego].self, from: data)
                if (self.listjuegos == nil){
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Atención", message: "Todavía no hay ningún juego.", preferredStyle: .alert)
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
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func tableSettings() {
       self.resultsController.tableView.dataSource = self
       self.resultsController.tableView.delegate = self
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        self.filteredGames = self.listjuegos.filter { (juego: Juego) -> Bool in
            if juego.titulo.lowercased().contains(self.searchController.searchBar.text!.lowercased()){
                return true
            }else{
                return false
            }
        }
        self.resultsController.tableView.reloadData()
    }
    
    func searchBar() {
        // MIRAR AQUI
        //https://stackoverflow.com/questions/51469253/uisearchbar-in-uinavigationcontroller
        self.searchController = UISearchController(searchResultsController: self.resultsController)
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchBar.placeholder = "Buscar"
        navigationItem.searchController?.dimsBackgroundDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
        self.searchController.searchBar
        let textFieldInsideUISearchBar = self.searchController.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideUISearchBar?.textColor = UIColor.white
        self.searchController.searchResultsUpdater = self
        self.navigationController!.navigationBar.tintColor = UIColor.white
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
    }
    
    func creatingSearhBar() {
        self.searchController = UISearchController(searchResultsController: self.resultsController)
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.searchController.searchResultsUpdater = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       if tableView == self.tableView {
            return listjuegos.count
       }
       else {
          return filteredGames.count
       }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListGameTableViewCell
        tableView.backgroundColor = .black
        if tableView == self.tableView {
            cell.label.text = self.listjuegos[indexPath.row].titulo
            cell.lbtipo.text = self.listjuegos[indexPath.row].tipo
            if(self.listjuegos[indexPath.row].media != "0.00"){
                cell.lbMedia.text = String(self.listjuegos[indexPath.row].media!)
            }else{
                cell.lbMedia.text = "N/A"
            }
            let urlImagen = Routes.uploads + self.listjuegos[indexPath.row].caratula
            if let url = URL(string: urlImagen) {
                let cola = DispatchQueue(label: "poner.imagen", qos: .default, attributes: .concurrent)
                cola.async {
                    if let data = try? Data(contentsOf: url), let imagen = UIImage(data: data) {
                        DispatchQueue.main.async {
                            cell.ivImagen.image = imagen
                        }
                    }
                }
            }
        }else{
            cell.label.text = filteredGames[indexPath.row].titulo
            cell.lbtipo.text = filteredGames[indexPath.row].tipo
            if(filteredGames[indexPath.row].media != "0.00"){
                cell.lbMedia.text = String(filteredGames[indexPath.row].media!)
            }else{
                cell.lbMedia.text = "N/A"
            }
            cell.lbMedia.text = String(filteredGames[indexPath.row].media!)
            let urlImagen = Routes.uploads + filteredGames[indexPath.row].caratula
            if let url = URL(string: urlImagen) {
                let cola = DispatchQueue(label: "poner.imagen", qos: .default, attributes: .concurrent)
                cola.async {
                    if let data = try? Data(contentsOf: url), let imagen = UIImage(data: data) {
                        DispatchQueue.main.async {
                            cell.ivImagen.image = imagen
                        }
                    }
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(self.filteredGames.count == 0){
            let preferences = UserDefaults.standard
            let value = self.listjuegos[indexPath.row].id
            let name = "idjuego"
            preferences.set(value, forKey: name)
            performSegue(withIdentifier: "goToSingle", sender: UIButton.self)
        }else{
            let preferences = UserDefaults.standard
            let value = self.filteredGames[indexPath.row].id
            let name = "idjuego"
            preferences.set(value, forKey: name)
            performSegue(withIdentifier: "goToSingle", sender: UIButton.self)
        }
    }
    
    //https://medium.com/infancyit/traveling-through-the-app-the-segue-magic-part-1-a8091e863164
    // SIN NAVIGATION
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSingle" {
             let vc = segue.destination as! SingleViewController
             vc.juego = juegoListo
        }
    }*/
    
    
//https://stackoverflow.com/questions/19774583/setting-a-property-in-a-segue-with-navigation-controller-containing-another-view
    //CON NAVIGATION
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSingle" {
            var DestViewController = segue.destination as! UITabBarController
            let targetController = DestViewController.viewControllers![0] as! SingleViewController
            targetController.juego = juegoListo
            
            //Shared preferences para el id del juego
            let preferences = UserDefaults.standard
            let value = juegoListo!.id
            let name = "idjuego"
            preferences.set(value, forKey: name)
        }
    }*/
    
    // CON TABBARVIEWCONTROLLER
    //https://stackoverflow.com/questions/29572744/prepare-for-segue-to-uitabbarcontroller-tab
}
