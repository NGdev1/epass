
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
    
    case showPass(
        id: String,
        deviceId: String
    )
    
    public var path: String {
        switch self {
        case .getPasses:
            return "get_passes"
        case .getOrganizations:
            return "get_organizations"
        case .requestPass:
            return "send_pass_request"
        case .showPass:
            return "show_pass"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .getPasses, .getOrganizations, .showPass:
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
                          "user_phone": "8" + userPhone,
                          "user_fio": userFio,
                          "user_photo": userPhoto,
                          "child_fio": childFio,
                          "child_born": childBorn,
                          "teach_phone": "8" + teacherPhone,
                          "org_id": organizationId
                ])
        case .showPass(let id, let deviceId):
            return .url(["id": id, "device_id": deviceId])
        }
    }
    
    public var headers: [String : Any]? {
        return [:]
    }
    
    public var dataType: DataType {
        return .Data
    }
}
