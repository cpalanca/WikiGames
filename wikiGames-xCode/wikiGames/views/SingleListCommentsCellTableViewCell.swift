//
//  SingleListCommentsCellTableViewCell.swift
//  wikiGames
//
//  Created by DAW on 19/02/2020.
//  Copyright © 2020 Carlos Palanca Giménez. All rights reserved.
//

import UIKit

class SingleListCommentsCellTableViewCell: UITableViewCell {

    @IBOutlet weak var lbDescription: UILabel!
    @IBOutlet weak var lbAlias: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
