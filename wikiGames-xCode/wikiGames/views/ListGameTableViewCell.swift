//
//  ListGameTableViewCell.swift
//  wikiGames
//
//  Created by DAW on 10/02/2020.
//  Copyright © 2020 Carlos Palanca Giménez. All rights reserved.
//

import UIKit

class ListGameTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var lbtipo: UILabel!
    @IBOutlet weak var ivImagen: UIImageView!
    @IBOutlet weak var lbMedia: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
