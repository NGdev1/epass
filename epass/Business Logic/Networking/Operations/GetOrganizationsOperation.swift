
import UIKit
import SwiftyJSON

class GetOrganizationsOperation: NetworkingOperation {
    
    var request: Request
    
    init() {
        request = Requests.getOrganizations
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
