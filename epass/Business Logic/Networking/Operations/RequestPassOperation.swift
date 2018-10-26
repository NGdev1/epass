//
//  RequestPassOperation.swift
//  epass
//
//  Created by Apple on 26.03.2018.
//  Copyright © 2018 md. All rights reserved.
//

import Foundation
import SwiftyJSON

class RequestPassOperation: NetworkingOperation {
    
    var request: Request
    
    init(deviceId: String,
         userPhone: String,
         userFio: String,
         userPhoto: String,
         childFio: String,
         childBorn: String,
         teacherPhone: String,
         organizationId: String) {
        request = Requests.requestPass(deviceId: deviceId,
                                       userPhone: userPhone,
                                       userFio: userFio,
                                       userPhoto: userPhoto,
                                       childFio: childFio,
                                       childBorn: childBorn,
                                       teacherPhone: teacherPhone,
                                       organizationId: organizationId)
    }
    
    func execute(in dispatcher: NetworkingDispatcher, completionHandler: @escaping (JSON?, Error?) -> Void) -> URLSessionDataTask {
        
        return dispatcher.execute(request: request,
                                  completionHandler: { (data, response, error) in
                                    if let err = error {
                                        completionHandler(nil, err)
                                        return
                                    } else {
                                        if response?.statusCode != 200 || data == nil {
                                            completionHandler(nil, APIErrors.unknounError)
                                        } else {
                                            let json = try! JSON(data: data!)
                                            completionHandler(json, nil)
                                        }
                                    }
        })
    }
}
