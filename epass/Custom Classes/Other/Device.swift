//
//  Device.swift
//  MyVkNews
//
//  Created by Apple on 22.06.17.
//  Copyright © 2017 flatstack. All rights reserved.
//

import Foundation
import UIKit

class Device {
    
    static func getDeviceId() -> String {
        return UIDevice.current.identifierForVendor!.uuidString
    }
    
    static func getDevicePlatform() -> String {
        return "IOS" + UIDevice.current.systemVersion
    }
    
    static func getDeviceName() -> String {
        return UIDevice.current.name
    }

}
