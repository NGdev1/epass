//
//  UIImage.swift
//  idtp
//
//  Created by Apple on 28.03.2018.
//  Copyright © 2018 md. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func scale(maximumWidth: CGFloat) -> UIImage {
        let prop = maximumWidth / self.size.width
        
        let rect = CGSize(width: maximumWidth, height: self.size.height * prop)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(rect, false, 1.0)
        self.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: rect))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

extension UIImage {
    
    static func fromBase64String(_ base64String: String) -> UIImage? {
        let dataDecoded: Data = Data(base64Encoded: base64String, options: .ignoreUnknownCharacters)!
        let decodedImage = UIImage(data: dataDecoded)
        return decodedImage
    }
    
    func base64String() -> String {
        let data = self.jpegData(compressionQuality: 0.8)
        let base64String = data!.base64EncodedString()
        return base64String
    }
    
    
}
