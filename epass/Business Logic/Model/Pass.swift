//
//  Pass.swift
//  epass
//
//  Created by Apple on 16.05.2018.
//  Copyright © 2018 md. All rights reserved.
//

import Foundation

enum PassStatus: Int {
    case waitForConfirmation = 0
    case disposable = 1
    case reusable = 2
    case deleted = 3
    
    var title: String {
        switch self {
        case .waitForConfirmation:
            return "Ожидает подтверждения"
        case .disposable:
            return "Разовый пропуск"
        case .reusable:
            return "Многоразовый пропуск"
        default:
            return "Удален"
        }
    }
}

class Pass {
    var id: Int?
    var status: PassStatus?
    var statusText: String?
    var cabinets: String?
}
