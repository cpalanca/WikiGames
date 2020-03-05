//
//  SingleListCommentsTableViewController.swift
//  wikiGames
//
//  Created by DAW on 19/02/2020.
//  Copyright © 2020 Carlos Palanca Giménez. All rights reserved.
//

import UIKit

class SingleListCommentsTableViewController: UITableViewController {
    
    var listcomentarios = [Comentario]()
    var resultsController = UITableViewController()
    var navitemprev:UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableSettings()
        navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController!.navigationBar.isTranslucent = false
        
        fillListComents()
        self.navitemprev = self.tabBarController?.navigationItem.rightBarButtonItem
        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Comentar", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.goToAddComment))
    }
    
    @objc func goToAddComment(){
        self.performSegue(withIdentifier: "goToAddComments", sender: UIButton.self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.tabBarController?.navigationItem.rightBarButtonItem = self.navitemprev
    }

    func fillListComents(){
        let preferences = UserDefaults.standard
        let name = "idjuego"
        let id = preferences.object(forKey: name)!
        var ok = HttpClient.get("comentario/comentariosjuego/\(id)") { (data) in
            guard let data = data else{
                return
            }
            do {
                let decoder = JSONDecoder()
                self.listcomentarios = try decoder.decode([Comentario].self, from: data)
                if (self.listcomentarios == nil){
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Atención", message: "Todavía no hay ningún comentario.", preferredStyle: .alert)
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.listcomentarios.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SingleListCommentsCellTableViewCell
        tableView.backgroundColor = .black
        cell.lbDescription.text = self.listcomentarios[indexPath.row].comentario
        cell.lbAlias.text = self.listcomentarios[indexPath.row].alias
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
