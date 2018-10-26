//
//  PassRequest.swift
//  epass
//
//  Created by Apple on 16.05.2018.
//  Copyright © 2018 md. All rights reserved.
//

import Foundation
import UIKit

class PassRequest {

    var organization: Organization?
    
    var parentFio: String?
    var parentPhone: String?
    
    var childPhoto: UIImage?
    
    var childFio: String?
    var childBorn: Date?
    
    var teacherPhone: String?
}
