
import Foundation
import SwiftyJSON

public enum Requests: Request {
    
    case getPasses(
        deviceId: String
    )
    
    case requestPass(
        deviceId: String,
        userPhone: String,
        userFio: String,
        userPhoto: String,
        childFio: String,
        childBorn: String,
        teacherPhone: String,
        organizationId: String
    )
    
    case getOrganizations
    
    public var path: String {
        switch self {
        case .getPasses:
            return "get_passes"
        case .getOrganizations:
            return "get_organizations"
        case .requestPass:
            return "send_pass_request"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .getPasses, .getOrganizations:
            return .get
        case .requestPass:
            return .post
        }
    }
    
    public var parameters: RequestParams {
        switch self {
        case .getPasses(let deviceId):
            return .url(["device_id": deviceId])
            
        case .getOrganizations:
            return .url([:])
            
        case .requestPass(let deviceId,
                          let userPhone,
                          let userFio,
                          let userPhoto,
                          let childFio,
                          let childBorn,
                          let teacherPhone,
                          let organizationId):
            return .body(["device_id": deviceId,
                          "user_phone": "+7" + userPhone,
                          "user_fio": userFio,
                          "user_photo": userPhoto,
                          "child_fio": childFio,
                          "child_born": childBorn,
                          "teach_phone": "+7" + teacherPhone,
                          "org_id": organizationId
                ])
        }
    }
    
    public var headers: [String : Any]? {
        return [:]
    }
    
    public var dataType: DataType {
        return .Data
    }
}
