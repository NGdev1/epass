//
//  UIView+ActivityIndicator.swift
//  Mouse
//
//  Created by Andreichev Michail on 27.10.2018
//  Copyright © 2017 epass. All rights reserved.
//

import UIKit

extension UIView {
    private var hudView: HudView? {
        get {
            for case let subview as HudView in subviews {
                return subview
            }
            return nil
        }
    }
    
    func startShowingActivityIndicator(with backgroundColor: UIColor = UIColor.black.withAlphaComponent(0.0)) {
        hudView?.removeFromSuperview()
        
        let hud = HudView(frame: self.frame)
        hud.backgroundColor = backgroundColor
        hud.translatesAutoresizingMaskIntoConstraints = false
        addSubview(hud)
        
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: hud, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: hud, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: hud, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: hud, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
    }
    
    func stopShowingActivityIndicator() {
        hudView?.removeFromSuperview()
    }
}

private class HudView: UIView {
    
    var loadingView: LoadingView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareAppearance()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        prepareAppearance()
    }
    
    private func prepareAppearance() {
        
        loadingView = LoadingView(frame: CGRect(x: 0,
                                                y: 0,
                                                width: self.frame.width,
                                                height: 13))
        loadingView?.color = ColorHelper.color(for: .baseTintColor)
        loadingView?.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(loadingView!)
        loadingView?.start()
        
        loadingView?.heightAnchor.constraint(equalToConstant: 20).isActive = true
        loadingView?.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: loadingView, attribute: .centerX, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: loadingView, attribute: .centerY, multiplier: 1.0, constant: 0).isActive = true
    }
}
