//
//  WebsiteController.swift
//  wikiGames
//
//  Created by Carlos Palanca Giménez on 17/02/2020.
//  Copyright © 2020 Carlos Palanca Giménez. All rights reserved.
//

import UIKit
import WebKit

class WebsiteController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let urlCarga = URL(string: Routes.website)
        let urlParaver = urlCarga ?? URL(string: Routes.website+"/404.php")
        webView.load(URLRequest(url: urlParaver!))
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
