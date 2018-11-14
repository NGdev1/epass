//
//  LoadingView.swift
//  epass
//
//  Created by Михаил Андреичев on 23/10/2018.
//  Copyright © 2018 MichailAndreichev. All rights reserved.
//

import Foundation
import UIKit

class LoadingView: UIView {
    var radius: CGFloat!
    var displayLink: CADisplayLink!
    var shapeLayer: CAShapeLayer!
    
    var speed: Double = 0.05
    var offset: Double = 0.0
    var color: UIColor!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        color = UIColor.white
        radius = frame.size.height
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func update() {
        
        let path: CGMutablePath = CGMutablePath()
        self.offset += speed
        
        let radius1 = CGFloat(1.0 + 0.4 * abs(sin(offset))) * self.radius
        path.addEllipse(in: CGRect(x: self.frame.width / 2 - radius - radius1,
                                   y: 0,
                                   width: radius1,
                                   height: radius1))
        
        let radius2 = CGFloat(1.0 + 0.4 * abs(sin(offset + 3.14 / 8))) * self.radius
        path.addEllipse(in: CGRect(x: self.frame.width / 2 - radius2 / 2,
                                   y: 0,
                                   width: radius2,
                                   height: radius2))
        
        let radius3 = CGFloat(1.0 + 0.4 * abs(sin(offset + 6.28 / 8))) * self.radius
        path.addEllipse(in: CGRect(x: self.frame.width / 2 + radius,
                                   y: 0,
                                   width: radius3,
                                   height: radius3))
        
        shapeLayer.path = path
        path.closeSubpath()
    }
    
    func start() {
        if (self.shapeLayer != nil) {
            return
        }
        
        self.shapeLayer = CAShapeLayer(layer: layer)
        self.shapeLayer.fillColor = self.color.cgColor
        
        self.layer.addSublayer(shapeLayer)
        
        self.displayLink = CADisplayLink(target: self,
                                         selector: #selector(update))
        self.displayLink.add(to: .main, forMode: .common)
    }
    
    func stop() {
        self.displayLink.invalidate()
        self.displayLink = nil
        self.shapeLayer = nil
    }
}
