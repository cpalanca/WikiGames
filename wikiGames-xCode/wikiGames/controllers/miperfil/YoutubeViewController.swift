//
//  YoutubeViewController.swift
//  wikiGames
//
//  Created by dam on 20/02/2020.
//  Copyright © 2020 Carlos Palanca Giménez. All rights reserved.
//
import Alamofire
import UIKit

class YoutubeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet weak var tableView: UITableView!
    let API_KEY = "AIzaSyARy9Y2fmlL6la-2iuRYZMqgj_ih8UzTjg"
    var videos:[Video] = [Video]()
    var selectedVideo:Video?
    var searchedGame:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.tintColor = UIColor.black
        self.navigationController!.navigationBar.isTranslucent = false
        //let model = VideoModel()
        //self.videos = model.getVideos()
        getSearchVideos(searchedGame!)
        // Do any additional setup after loading the view.
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        
    }
    
    func getSearchVideos(_ word: String) {
        var arrayOfVideos = [Video]()

        let parameters = ["q" : word, "part" : "snippet", "mine" : "true", "type" : "video", "key" : API_KEY]
        AF.request("https://www.googleapis.com/youtube/v3/search", parameters: parameters).responseJSON { response in
            //print("\(response)")
            if let JSON = response.value{
                    if let dictionary = JSON as? [String:Any]{
                        for item in dictionary["items"] as! NSArray {
                            //Creo los objetos de video recorriendo el JSON
                            let videoObj = Video()
                            videoObj.videoId = (item as AnyObject).value(forKeyPath: "id.videoId") as! String
                            videoObj.videoTitle = (item as AnyObject).value(forKeyPath: "snippet.title") as! String
                            videoObj.videoDescripcion = (item as AnyObject).value(forKeyPath: "snippet.description") as! String
                            arrayOfVideos.append(videoObj)
                        }
                }
                // Ya han sido contruidos los objetos por lo que debo recargar la tabla
                self.videos = arrayOfVideos
                DispatchQueue.main.async {
                    self.do_table_refresh();
                }
            }
        }
        
    }


    func do_table_refresh(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
            return
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (self.view.frame.size.width / 320) * 180
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(videos.count)
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Take note wich video is selected
        self.selectedVideo = self.videos[indexPath.row]
        // LLamar al segue
        self.performSegue(withIdentifier: "goToDetailVideo", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Coger la referencia del destino del viewController
        let detailViewController = segue.destination as! VideoDetailViewController
        // poner el objeto del video
        detailViewController.selectedVideo = self.selectedVideo
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "videosCell")!
        let videoTitle = videos[indexPath.row].videoTitle
        
        let label = cell.viewWithTag(2) as! UILabel
        label.text = videoTitle
        
        let urlImagen = "https://i1.ytimg.com/vi/\(videos[indexPath.row].videoId)/maxresdefault.jpg"
        if let url = URL(string: urlImagen) {
            let cola = DispatchQueue(label: "poner.imagen", qos: .default, attributes: .concurrent)
            cola.async {
                if let data = try? Data(contentsOf: url), let imagen = UIImage(data: data) {
                    DispatchQueue.main.async {
                        let imageView = cell.viewWithTag(1) as! UIImageView
                            imageView.image = imagen
                    }
                }
            }
        }
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
