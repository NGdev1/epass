
import UIKit
import SwiftyJSON

protocol APIServiceSharier {
    var sharedAPIService: APIService {get}
}

class APIService: NSObject {
    
    public static let baseURLServer = "http://178.206.224.220:98/electronic_pass/api/"
    
    private let environmentMain: NetworkingEnvironment
    private let dispatcherMain: NetworkingDispatcher

    static func shared() -> APIService {
        return (UIApplication.shared.delegate as! APIServiceSharier).sharedAPIService
    }
    
    override init() {
        environmentMain = NetworkingEnvironment("main", host: APIService.baseURLServer)
        dispatcherMain = ConcreateNetworkingDispatcher(environment: environmentMain)
    }
    
    public func getPasses(deviceId: String, completionHandler: @escaping(JSON?, Error?) -> Void) -> URLSessionDataTask {
        let operation = GetPassesOperation(deviceId: deviceId)
        
        return operation.execute(in: dispatcherMain, completionHandler: completionHandler)
    }
    
    public func getOrganizations(completionHandler: @escaping(JSON?, Error?) -> Void) -> URLSessionDataTask {
        let operation = GetOrganizationsOperation()
        
        return operation.execute(in: dispatcherMain, completionHandler: completionHandler)
    }
    
    public func requestPass(deviceId: String, passRequest: PassRequest, completionHandler: @escaping(JSON?, Error?) -> Void) -> URLSessionDataTask {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY"
        
        let operation = RequestPassOperation(deviceId: deviceId,
                                             userPhone: passRequest.parentPhone!,
                                             userFio: passRequest.parentFio!,
                                             userPhoto: passRequest.childPhoto!.scale(maximumWidth: 800).base64String(),
                                             childFio: passRequest.childFio!,
                                             childBorn: dateFormatter.string(from: passRequest.childBorn!),
                                             teacherPhone: passRequest.teacherPhone!,
                                             organizationId: String(passRequest.organization!.id!))
        
        return operation.execute(in: dispatcherMain, completionHandler: completionHandler)
    }
}
