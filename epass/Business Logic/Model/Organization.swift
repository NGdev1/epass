//
//  Organization
//  epass
//
//  Created by Apple on 16.05.2018.
//  Copyright © 2018 md. All rights reserved.
//

import Foundation
import UIKit

enum OrganizationType: Int {
    case creativityCentre = 1
    case sportPalace = 2
    case school = 3
    
    var image: UIImage {
        switch self {
        case .creativityCentre:
            return #imageLiteral(resourceName: "CreativityHouse")
        case .sportPalace:
            return #imageLiteral(resourceName: "SportHouse")
        case .school:
            return #imageLiteral(resourceName: "School")
        }
    }
}

class Organization {
    var id: Int?
    var type: OrganizationType?
    var name: String?
}
