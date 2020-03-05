//
//  VideoDetailViewController.swift
//  wikiGames
//
//  Created by dam on 20/02/2020.
//  Copyright © 2020 Carlos Palanca Giménez. All rights reserved.
//

import UIKit
import WebKit

class VideoDetailViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var decriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var webViewConstraintHeigth: NSLayoutConstraint!
    var selectedVideo:Video?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // lo recojo aqui porque ya se ha formado mi layout variable dependiendo del tamaño del dispositivo
        
        if let vid = self.selectedVideo{
            self.titleLabel.text = vid.videoTitle
            self.decriptionLabel.text = vid.videoDescripcion
            let width = self.view.frame.size.width
            let height = width/320 * 180
            
            //https://www.youtube.com/watch?v=YGIyaim_5kw
            //Ajustar el heigth del webview
            self.webViewConstraintHeigth.constant = height
            let videoEmbedString = "<html><head><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'><style type=\"text/css\">body {background-color: transparent;color: white;}</style></head><body style=\"margin:0\"><iframe frameBorder=\"0\" height=\"" + String("\(height)") + "\" width=\"" + String("\(width)") + "\" src=\"http://www.youtube.com/embed/" + vid.videoId + "?showinfo=0&modestbranding=1&frameborder=0&rel=0\"></iframe></body></html>"
            self.webView.loadHTMLString(videoEmbedString, baseURL: nil)
        }
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
