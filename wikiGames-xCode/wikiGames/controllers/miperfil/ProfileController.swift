//
//  ProfileController.swift
//  wikiGames
//
//  Created by Carlos Palanca Giménez on 04/02/2020.
//  Copyright © 2020 Carlos Palanca Giménez. All rights reserved.
//


import UIKit

class ProfileController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    //https://itnext.io/programmatic-custom-collectionview-cell-subclass-in-swift-5-xcode-10-291f8d41fdb1
    //https://guides.codepath.com/ios/Using-UICollectionView
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var labelAlias: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    var listjuegos = [Juego]()
    var titleJuegoSearchWord : String!
    let preferences = UserDefaults.standard
    let name = "alias"
    // MARK: - Lifecycle
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /*override func viewDidAppear(_ animated: Bool) {
        print("didappear")
        collectionView.delegate = self
        collectionView.dataSource = self
        //https://sexyswift.wordpress.com/tag/uicollectionviewflowlayout/
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true
        let myView = UIView(frame: self.view.frame)
        let image = UIImage(named: "bg-home")
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: image!.size))
        imageView.image = image
        myView.addSubview(imageView)
        collectionView.backgroundView = myView
        fillListGames("\(preferences.object(forKey: name)!)")
        fillUserName()
    }*/
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.delegate = self
        collectionView.dataSource = self
        print("willappear")
        self.listjuegos.removeAll()
        //AppUtility.lockOrientation(.landscape)
        // Or to rotate and lock
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
          //https://www.tutorialspoint.com/how-to-create-transparent-status-bar-and-navigation-bar-in-ios
        self.navigationController!.navigationBar.tintColor = UIColor.white
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        //https://sexyswift.wordpress.com/tag/uicollectionviewflowlayout/
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true
        collectionView.frame.size.width = view.frame.width
        let myView = UIView(frame: self.view.frame)
        let image = UIImage(named: "bg-home")
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: image!.size))
        imageView.image = image
        myView.addSubview(imageView)
        collectionView.backgroundView = myView
        fillListGames("\(preferences.object(forKey: name)!)")
        fillUserName()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("willdisappear")
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
        
        // Restore the navigation bar to default
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    func fillListGames(_ alias: String?){
        var ok = HttpClient.get("juego/interaccion/\(alias!)") { (data) in
            guard let data = data else{
                return
            }
            do {
                let decoder = JSONDecoder()
                self.listjuegos = try decoder.decode([Juego].self, from: data)
                if (self.listjuegos == nil){
                    print(self.listjuegos.count)
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
            self.collectionView.reloadData()
            return
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionInsets = UIEdgeInsets(top: 2.0, left: 2.0, bottom: 10.0, right: 2.0)
        let paddingSpace = sectionInsets.left * 4
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem  = availableWidth/3
        return CGSize(width: ceil(widthPerItem), height: ceil(widthPerItem))
        /*var totalHeight: CGFloat = (self.view.frame.width / 3)
        var totalWidth: CGFloat = (self.view.frame.width / 3)
        //print(totalWidth) // this prints 106.666666667
        return CGSize(width: ceil(totalWidth), height: ceil(totalHeight))
        */
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let sectionInsets = UIEdgeInsets(top: 2.0, left: 2.0, bottom: 10.0, right: 2.0)
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listjuegos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let identifier = "myGamesCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! MyGamesCollectionViewCell
        // PARA QUE SEAN REDONDOS
        
        let sectionInsets = UIEdgeInsets(top: 2.0, left: 2.0, bottom: 2.0, right: 2.0)
        let paddingSpace = sectionInsets.left * 4
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem  = availableWidth/3
        
        cell.contentView.layer.cornerRadius = widthPerItem/2
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true;

        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width:0,height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false;
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
        
        cell.etiqueta.isHidden = true        
        cell.etiqueta.text = listjuegos[indexPath.row].titulo
        let urlImagen = Routes.uploads + self.listjuegos[indexPath.row].caratula
        if let url = URL(string: urlImagen) {
            let cola = DispatchQueue(label: "poner.imagen", qos: .default, attributes: .concurrent)
            cola.async {
                if let data = try? Data(contentsOf: url), let imagen = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.imagen.image = imagen
                    }
                }
            }
        }
        //cell.imagen.image = UIImage.init(imageLiteralResourceName: listjuegos[indexPath.row].caratula)
        //cell.etiqueta.text = "hola"
        //cell.imagen.image = UIImage(imageLiteralResourceName: "single-image")
        return cell
    }
   func testAlert(_ titulo: String){
        let alert = UIAlertController(title: "Titulo",message: titulo, preferredStyle: .alert)
        alert.setValue(NSAttributedString(string: "Titulo", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17),NSAttributedString.Key.foregroundColor : UIColor.white]), forKey: "attributedTitle")
        alert.setValue(NSAttributedString(string: titulo, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium), NSAttributedString.Key.foregroundColor : UIColor.white]), forKey: "attributedMessage")
        let dismissAction = UIAlertAction(title: "Continuar", style: .default, handler: nil)

        // Accessing alert view backgroundColor :
        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.black

        // Accessing buttons tintcolor :
        alert.view.tintColor = UIColor.white

        alert.addAction(dismissAction)
        present(alert, animated: true, completion:  nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        //testAlert(listjuegos[indexPath.row].titulo)
        /*let alert = UIAlertController(title: "Titulo", message: listjuegos[indexPath.row].titulo, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continuar", style: .default, handler: nil))
        self.present(alert, animated: true)*/
        // Take note wich video is selected
        self.titleJuegoSearchWord = listjuegos[indexPath.row].titulo
        // LLamar al segue
        self.performSegue(withIdentifier: "goSearchVideoOnYoutube", sender: self)
        return true
    }
    
    func fillUserName(){
        labelAlias.text = "\(preferences.object(forKey: name)!)"
        requestUserByAlias("\(preferences.object(forKey: name)!)")
    }
    
    func requestUserByAlias(_ alias: String?){
        var ok = HttpClient.get("getinfousuario/\(alias!)") { (data) in
            guard let data = data else{
                return
            }
            do {
                let decoder = JSONDecoder()
                let resultado = try decoder.decode(Usuario.self, from: data)
                //print("El resultado es: \(resultado)")
                if ((resultado.alias).elementsEqual(alias!)){
                    DispatchQueue.main.async {
                        self.labelEmail.text = resultado.correo
                    }
                }else{
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Error", message: "No hemos podido recuperar toda la info de tu usuario.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "De acuerdo", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                }
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
    }
    
        
        // MARK: - ACTIONS
    
    @IBAction func btMyRatings(_ sender: UIButton) {
        self.performSegue(withIdentifier: "showRatingList", sender: UIButton.self)
    }
    
    @IBAction func btMyCommentsList(_ sender: UIButton) {
        self.performSegue(withIdentifier: "showMyCommentsList", sender: UIButton.self)
    }
    
    @IBAction func btGoWebsite(_ sender: UIButton) {
        // CON WKWEBVIEW
        self.performSegue(withIdentifier: "goWebsite", sender: UIButton.self)
        /* ABRIENDO SAFARI SOLO
         if let url = URL(string: Routes.website) {
            UIApplication.shared.open(url)
        }*/
    }
    
    @IBAction func btLogout(_ sender: UIButton) {
        //Borrar alias del user default
        let preferences = UserDefaults.standard
        let name = "alias"
        preferences.set(nil, forKey: name)
        //Segue al login
        self.performSegue(withIdentifier: "backToLogin", sender: UIButton.self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goSearchVideoOnYoutube" {
             let vc = segue.destination as! YoutubeViewController
             vc.searchedGame = titleJuegoSearchWord
        }
    }
    /* con NAVIGATION
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goSearchVideoOnYoutube" {
            let DestViewController = segue.destination as! UINavigationController
            let targetController = DestViewController.topViewController as! YoutubeViewController
            targetController.searchedGame = titleJuegoSearchWord
        }
    }
 */
}


struct AppUtility {

    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {

        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }

    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {

        self.lockOrientation(orientation)

        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
    }

}
