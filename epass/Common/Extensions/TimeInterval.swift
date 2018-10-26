//
//  TimeInterval.swift
//  idtp
//
//  Created by Apple on 28.03.2018.
//  Copyright © 2018 md. All rights reserved.
//

import Foundation

extension TimeInterval {
    func getStringDescription() -> String {
        let interval = Int(self)
        
        let days = (interval / (3600 * 24))
        
        if days == 1 { return "вчера" }
        
        let hours = (interval / 3600) % 24
        
        if hours == 0 {
            let minutes = interval / 60
            return String(format: "%d минут назад", minutes)
        }
        if hours == 1 { return "час назад" }
        if hours == 2 { return "2 часа назад" }
        if hours == 3 { return "3 часа назад" }
        if hours == 4 { return "4 часа назад" }
        
        return String(format: "%d часов назад", hours)
    }
}
