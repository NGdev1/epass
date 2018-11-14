//
//  PassCell.swift
//  epass
//
//  Created by Михаил Андреичев on 18/10/2018.
//  Copyright © 2018 MichailAndreichev. All rights reserved.
//

import UIKit
import SDWebImage

class PassCell: UITableViewCell {

    @IBOutlet weak var imageViewPhoto: UIImageView!
    @IBOutlet weak var labelOrganization: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var labelStatusText: UILabel!
    @IBOutlet weak var labelCabinets: UILabel!
    @IBOutlet weak var labelClientName: UILabel!
    @IBOutlet weak var labelChildName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageViewPhoto.layer.masksToBounds = true
        imageViewPhoto.sd_setShowActivityIndicatorView(true)
        imageViewPhoto.sd_setIndicatorStyle(.gray)
    }
}
