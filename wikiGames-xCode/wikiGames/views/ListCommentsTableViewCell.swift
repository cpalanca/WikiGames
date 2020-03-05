//
//  ListCommentsTableViewCell.swift
//  wikiGames
//
//  Created by Carlos Palanca Giménez on 18/02/2020.
//  Copyright © 2020 Carlos Palanca Giménez. All rights reserved.
//

import UIKit

class ListCommentsTableViewCell: UITableViewCell {

    @IBOutlet weak var ivCaratula: UIImageView!
    @IBOutlet weak var labelTitulo: UILabel!
    @IBOutlet weak var labelComentario: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
