//
//  PassService.swift
//  epass
//
//  Created by Apple on 16.05.2018.
//  Copyright © 2018 md. All rights reserved.
//

import Foundation
import SwiftyJSON

class PassService {
    
    typealias LoadPassesResult = (passes: [Pass]?, error: Error?)
    
    static func loadPasses(deviceId: String, completionHandler: @escaping (LoadPassesResult) -> Void) {
        let _ = APIService.shared().getPasses(deviceId: deviceId,
                                              completionHandler:
            {
                body, error in
                
                if error != nil {
                    completionHandler(LoadPassesResult(passes: nil, error: error))
                    return
                }
                
                var passes = [Pass]()
                
                let passesJson = body!.arrayValue
                
                for passJson in passesJson {
                    let pass = Pass()
                    
                    pass.id = passJson["id"].int
                    pass.status = PassStatus(rawValue: passJson["status_code"].intValue)
                    pass.statusText = passJson["status_text"].string
                    pass.cabinets = passJson["cabinets"].string
                    
                    passes.append(pass)
                }
                
                completionHandler(LoadPassesResult(passes: passes, error: nil))
        })
    }
    
    static func passRequest(passRequest: PassRequest,
                            completionHandler: @escaping (String?) -> Void) {
        
        let deviceId = Device.getDeviceId()
        
        let _ = APIService.shared().requestPass(deviceId: deviceId, passRequest: passRequest, completionHandler: {
            json, error in
            
            if let err = error as! APIErrors? {
                if err == .noConnection {
                    completionHandler("Не удалось установить соединение")
                } else {
                    completionHandler("Произошла ошибка")
                }
            }
            
            guard let json = json else {
                completionHandler("Произошла ошибка")
                return
            }
            
            if json["error"].int != 0 {
                if let errorText = json["error_text"].string {
                    completionHandler(errorText)
                    return
                } else {
                    completionHandler("Произошла ошибка")
                    return
                }
            } else {
                completionHandler(nil)
            }
        })
    }
}
