//
//  TakePhotoDocument.swift
//  epass
//
//  Created by Михаил Андреичев on 21/10/2018.
//  Copyright © 2018 MichailAndreichev. All rights reserved.
//

import Foundation
import UIKit

class TakePhotoDocument: TakePhoto {
    
    var secondVcDelegate: SecondVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.imageSample != nil {
            self.imageView.image = self.imageSample
        }
        
        let backButton = UIBarButtonItem()
        backButton.title = "Назад"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        changeImageExistance()
        self.updateViewConstraints()
    }
    
    override func updateViewConstraints() {
        self.view.clearConstraints()
        
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        labelNoContent.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        labelNoContent.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30).isActive = true
        //labelNoContent.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 100).isActive = true
        
        imageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30).isActive = true
        
        var imageHeight = 100.0
        if imageView.image != nil {
            let prop = view.frame.width / imageView.image!.size.width
            imageHeight = Double(imageView.image!.size.height * prop)
        }
        
        imageView.heightAnchor.constraint(equalToConstant:
            CGFloat(imageHeight)).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        //imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -30).isActive = true
        
        buttonAdd.heightAnchor.constraint(equalToConstant: 45).isActive = true
        buttonAdd.widthAnchor.constraint(equalToConstant: 210).isActive = true
        buttonAdd.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        buttonAdd.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        super.updateViewConstraints()
    }
    
    override func imageDidSelected() {
        self.secondVcDelegate?.didFinishSecondVC(self)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func changeImageExistance(){
        if imageView.image != nil {
            labelNoContent.isHidden = true
            buttonAdd.isHidden = true
            imageView.isHidden = false
        } else {
            labelNoContent.isHidden = false
            buttonAdd.isHidden = false
            imageView.isHidden = true
        }
    }
}
