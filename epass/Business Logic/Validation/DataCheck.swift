//
//  DataCheck.swift
//  epass
//
//  Created by Apple on 28.03.2018.
//  Copyright © 2018 md. All rights reserved.
//

import Foundation

class DataCheck {
    
    static func check(passRequest : PassRequest) -> String? {
        
        if passRequest.parentFio == nil {
            return "Укажите ФИО родителя."
        }
        
        if passRequest.parentPhone != nil {
            if passRequest.parentPhone!.isEmpty {
                return "Укажите номер телефона родителя."
            } else if !self.validatePhoneNumber(passRequest.parentPhone!) {
                return "Укажите номер телефона родителя в правильном формате."
            }
        } else {
            return "Укажите номер телефона родителя."
        }
        
        if passRequest.childPhoto == nil {
            return "Укажите фотографию."
        }
        
        if passRequest.childFio == nil {
            return "Укажите ФИО ребенка."
        }
        
        if passRequest.childBorn == nil {
            return "Укажите дату рождения ребенка."
        }
        
        if passRequest.teacherPhone != nil {
            if passRequest.teacherPhone!.isEmpty {
                return "Укажите номер телефона учителя."
            } else if !self.validatePhoneNumber(passRequest.teacherPhone!) {
                return "Укажите номер телефона учителя в правильном формате."
            }
        } else {
            return "Укажите номер телефона учителя."
        }
        
        return nil
    }
    
    private static func validatePhoneNumber(_ candidate: String) -> Bool {
        let phoneNumberRegex = "^\\([0-9]{3}\\)[0-9]{3}-[0-9]{2}-[0-9]{2}$"
        
        let isValid = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex).evaluate(with: candidate)
        
        return isValid
    }
}
