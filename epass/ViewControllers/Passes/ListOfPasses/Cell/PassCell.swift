//
//  PassCell.swift
//  epass
//
//  Created by Михаил Андреичев on 18/10/2018.
//  Copyright © 2018 MichailAndreichev. All rights reserved.
//

import UIKit

class PassCell: UITableViewCell {

    @IBOutlet weak var imageViewPhoto: UIImageView!
    
    @IBOutlet weak var labelStatus: UILabel!
    
    @IBOutlet weak var labelStatusText: UILabel!
    
    @IBOutlet weak var labelCabinets: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
