//
//  ImageExtension.swift
//  wikiGames
//
//  Created by DAW on 11/02/2020.
//  Copyright © 2020 Carlos Palanca Giménez. All rights reserved.
//

import Foundation

class ImageExtension: UIImageView {
    override init() {
        super.init()
        load()
    }

    func load(url?: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
