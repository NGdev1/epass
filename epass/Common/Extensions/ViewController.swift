//
//  ViewController.swift
//  idtp
//
//  Created by Apple on 28.03.2018.
//  Copyright © 2018 md. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showError(_ message : String) {
        
        let alertController = UIAlertController(title: "", message:
            message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Назад", style: UIAlertAction.Style.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func askUser(_ question: String, actionNo: @escaping (UIAlertAction) -> Void, actionYes: @escaping (UIAlertAction) -> Void){
        let alertController = UIAlertController(title: question, message:
            "", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Нет", style: UIAlertAction.Style.default, handler: actionNo))
        alertController.addAction(UIAlertAction(title: "Да", style: UIAlertAction.Style.default, handler: actionYes))
        self.present(alertController, animated: true, completion: nil)
    }
}
