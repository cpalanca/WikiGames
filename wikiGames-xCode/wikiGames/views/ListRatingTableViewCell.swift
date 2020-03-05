//
//  RatingTableViewCell.swift
//
//  Created by Carlos Palanca on 17/02/2020.
//  Copyright © 2020 Carlos Palanca. All rights reserved.
//

import UIKit

class ListRatingTableViewCell: UITableViewCell {


    @IBOutlet weak var floatRatingView: FloatRatingView!
    @IBOutlet weak var ivJuego: UIImageView!
    @IBOutlet weak var tituloJuego: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
