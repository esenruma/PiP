//
//  ClassicCustomCell.swift
//  PiP
//
//  Created by Roma on 08/04/2016.
//  Copyright © 2016 esenruma. All rights reserved.
//

import UIKit

class ClassicCustomCell: UITableViewCell {

    
    @IBOutlet var tableImage: UIImageView!
    
    @IBOutlet var tableTitleLabel: UILabel!
     
    
// --------------------------------------------------------------
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
