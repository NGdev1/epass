//
//  ShowPassOperation.swift
//  epass
//
//  Created by Михаил Андреичев on 14/11/2018.
//  Copyright © 2018 MichailAndreichev. All rights reserved.
//

import Foundation
import UIKit

class ShowPassOperation: NetworkingOperation {
    
    var request: Request
    
    init(id: String,
         deviceId: String) {
        request = Requests.showPass(id: id, deviceId: deviceId)
    }
    
    func execute(in dispatcher: NetworkingDispatcher, completionHandler: @escaping (UIImage?, Error?) -> Void) -> URLSessionDataTask {
        
        return dispatcher.execute(request: request,
                                  completionHandler: { (data, response, error) in
                                    if let err = error {
                                        completionHandler(nil, err)
                                        return
                                    }
                                    
                                    if data != nil, let image = UIImage(data: data!) {
                                        completionHandler(image, nil)
                                    } else {
                                        completionHandler(nil, APIErrors.unknounError)
                                    }
        })
    }
}
