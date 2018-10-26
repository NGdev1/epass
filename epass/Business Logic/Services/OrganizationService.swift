//
//  OrganizationsService.swift
//  epass
//
//  Created by Apple on 16.05.2018.
//  Copyright © 2018 md. All rights reserved.
//

import Foundation
import SwiftyJSON

class OrganizationsService {
    
    typealias LoadOrganizationsResult = (organizations: [Organization]?, error: Error?)
    
    static func loadOrganizations(completionHandler: @escaping (LoadOrganizationsResult) -> Void) {
        let _ = APIService.shared().getOrganizations(completionHandler:
            {
                body, error in
                
                if error != nil {
                    completionHandler(LoadOrganizationsResult(organizations: nil, error: error))
                    return
                }
                
                var organizations = [Organization]()
                
                let organizationsJson = body!.arrayValue
                
                for organizationJson in organizationsJson {
                    let organization = Organization()
                    
                    organization.id = Int(organizationJson["id"].stringValue)
                    organization.type = OrganizationType(rawValue: organizationJson["type"].intValue)
                    organization.name = organizationJson["name"].string

                    organizations.append(organization)
                }
                
                completionHandler(LoadOrganizationsResult(organizations: organizations, error: nil))
        })
    }
}
