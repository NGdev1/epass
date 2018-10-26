//
//  TakePhoto.swift
//  epass
//
//  Created by Михаил Андреичев on 21/10/2018.
//  Copyright © 2018 MichailAndreichev. All rights reserved.
//

import UIKit
import SVProgressHUD
import Lightbox

class TakePhoto: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    var pickedImage: UIImage?
    var imageSample: UIImage?
    
    var imageView : UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    var imageGesture : UITapGestureRecognizer?
    
    var labelNoContent : UILabel = {
        var labelNoContent = UILabel()
        labelNoContent.translatesAutoresizingMaskIntoConstraints = false
        labelNoContent.text = "Нет фото"
        labelNoContent.textAlignment = .center
        labelNoContent.textColor = UIColor.gray
        return labelNoContent
    }()
    
    var scrollView : UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    var buttonAdd : UIButton = {
        var buttonAdd = UIButton()
        buttonAdd.translatesAutoresizingMaskIntoConstraints = false
        buttonAdd.setBackgroundImage(#imageLiteral(resourceName: "ButtonBackground"), for: .normal)
        buttonAdd.setTitle("Сделать фото", for: .normal)
        return buttonAdd
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        
        view.addSubview(scrollView)
        view.addSubview(buttonAdd)
        scrollView.addSubview(imageView)
        scrollView.addSubview(labelNoContent)
        scrollView.contentSize.width = view.frame.width
        
        imageGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(_:)))
        imageView.addGestureRecognizer(imageGesture!)
        
        buttonAdd.addTarget(self, action: #selector(self.takePhoto), for: .touchUpInside)
        
        self.view.backgroundColor = UIColor.groupTableViewBackground
        
        let rightItem = UIBarButtonItem(barButtonSystemItem: .camera,
                                        target: self,
                                        action: #selector(TakePhoto.takePhoto))
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc func takePhoto() {
        let alert:UIAlertController=UIAlertController(title: "Фото", message: nil, preferredStyle: UIAlertController.Style.alert)
        let cameraAction = UIAlertAction(title: "Камера", style: UIAlertAction.Style.default)
        {   UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Галерея", style: UIAlertAction.Style.default)
        {   UIAlertAction in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: "Назад", style: UIAlertAction.Style.cancel)
        
        // Add the actions
        imagePicker.allowsEditing = false
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera(){
        if(UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerController.SourceType.camera)) {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            present(imagePicker, animated: true, completion: nil)
        } else {
            self.showError("У тебя нет камеры")
        }
    }
    
    func openGallery(){
        if(UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerController.SourceType.savedPhotosAlbum)) {
            imagePicker.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
            present(imagePicker, animated: true, completion: nil)
        } else {
            self.showError("Галерея недоступна")
        }
    }
    
    //action on photo is selected
    func imageDidSelected(){
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        dismiss(animated: true, completion: nil)
        self.imageDidSelected()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func imageViewTapped(_ sender: UITapGestureRecognizer) {
        
        guard let image = imageView.image else {
            return
        }
        
        let images = [
            LightboxImage(
                image: image,
                text: "Фотография ребенка"
            )
        ]
        
        // Create an instance of LightboxController.
        let controller = LightboxController(images: images)
        
        // Use dynamic background.
        controller.dynamicBackground = true
        
        // Present your controller.
        present(controller, animated: true, completion: nil)
    }
}
