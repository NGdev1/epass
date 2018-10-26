//
//  ColorHelper.swift
//  Mouse
//
//  Created by Amir Zigangarayev on 09.11.2017.
//  Copyright © 2017 Mouse. All rights reserved.
//

import UIKit

class ColorHelper {
    
    enum ColorName {
        case baseTintColor
        case grayTextColor
        case lightGrayColor
    }
    
    static func color(for name: ColorName) -> UIColor {
        switch name {
        case .baseTintColor:
            return #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        case .grayTextColor:
            return #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        case .lightGrayColor:
            return #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
        }
    }
}
