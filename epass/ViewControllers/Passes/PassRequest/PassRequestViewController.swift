//
//  PassRequest.swift
//  epass
//
//  Created by Михаил Андреичев on 20/10/2018.
//  Copyright © 2018 MichailAndreichev. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON

class PassRequestViewController: UITableViewController, SecondVCDelegate {
    
    var passRequest = PassRequest()
    
    @IBOutlet weak var barButtonSend: UIBarButtonItem!
    
    @IBOutlet weak var labelOrganizationName: UILabel!
    
    @IBOutlet weak var textFieldParentFio: UITextField!
    @IBOutlet weak var textFieldParentPhone: UITextField!
    
    @IBOutlet weak var photoIndicator: UIImageView!
    
    @IBOutlet weak var textFieldChildFio: UITextField!
    @IBOutlet weak var labelChildBirthday: UILabel!
    @IBOutlet weak var datePickerChildBirthday: UIDatePicker!
    
    @IBOutlet weak var textFieldTeacherPhone: UITextField!
    
    @IBOutlet weak var buttonSend: UIButton!
    @IBOutlet weak var buttonRefuse: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem()
        backButton.title = "Назад"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        self.tableView.tableFooterView = UIView()
        self.tableView.keyboardDismissMode = .interactive
        
        self.buttonSend.addTarget(self,
                                  action: #selector(send),
                                  for: .touchUpInside)
        self.barButtonSend.target = self
        self.barButtonSend.action = #selector(send)
        self.buttonRefuse.addTarget(self,
                                    action: #selector(refuse),
                                    for: .touchUpInside)
        
        photoIndicator.isHidden = true
        
        datePickerChildBirthday.isHidden = true
        datePickerChildBirthday.addTarget(self,
                                          action: #selector(datePickerChanged(_:)),
                                          for: .valueChanged)
        datePickerChildBirthday.setDate(Date(), animated: false)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYYг."
        labelChildBirthday.text = dateFormatter.string(from: datePickerChildBirthday.date)
        
        //Set organization Name
        self.labelOrganizationName.text = passRequest.organization?.name
        
        self.textFieldChildFio.delegate = self
        self.textFieldParentFio.delegate = self
        self.textFieldParentPhone.delegate = self
        self.textFieldTeacherPhone.delegate = self
        addDoneButtonOnKeyboard()
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: view.bounds.width, height: 50)))
        doneToolbar.barStyle = UIBarStyle.blackTranslucent
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Далее", style: UIBarButtonItem.Style.plain, target: self, action: #selector(textFieldDoneButtonAction))
        done.tintColor = UIColor.white
        
        let items = [flexSpace, done]
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.textFieldParentPhone.inputAccessoryView = doneToolbar
        self.textFieldTeacherPhone.inputAccessoryView = doneToolbar
    }
    
    @objc func textFieldDoneButtonAction(){
        if textFieldParentPhone.isFirstResponder {
            textFieldParentPhone.resignFirstResponder()
        } else if textFieldTeacherPhone.isFirstResponder {
            textFieldTeacherPhone.resignFirstResponder()
            send()
        }
    }
    
    @objc func datePickerChanged(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYYг."
        
        labelChildBirthday.text = dateFormatter.string(from: datePickerChildBirthday.date)
        passRequest.childBorn = datePickerChildBirthday.date
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if datePickerChildBirthday.isHidden && indexPath.section == 3 && indexPath.row == 2 {
            return 0
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3 && indexPath.row == 1 {
            toggleDatepicker()
        } else if indexPath.section == 2 {
            
            let nextVC = TakePhotoDocument()
            nextVC.secondVcDelegate = self
            nextVC.imageView.image = self.passRequest.childPhoto
            nextVC.title = "Фото"
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func toggleDatepicker() {
        datePickerChildBirthday.isHidden = !datePickerChildBirthday.isHidden
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    @objc func refuse() {
        self.askUser("Удалить оформление?",
                     actionNo: { _ in
        },
                     actionYes: { _ in
                        self.navigationController?.popToRootViewController(animated: true)
                        
        })
    }
    
    @objc func send() {
        
        self.passRequest.parentFio = textFieldParentFio.text
        self.passRequest.parentPhone = textFieldParentPhone.text
        self.passRequest.childFio = textFieldChildFio.text
        self.passRequest.teacherPhone = textFieldTeacherPhone.text
        
        if let error = DataCheck.check(passRequest: self.passRequest) {
            self.showError(error)
            return
        }
        
        SVProgressHUD.show()
        PassService.passRequest(passRequest: self.passRequest, completionHandler: { error in
            SVProgressHUD.dismiss()
            if error != nil {
                self.showError(error!)
                return
            } else {
                SVProgressHUD.showSuccess(withStatus: "Успешно.")
                let _ = self.navigationController?.popToRootViewController(animated: true)
            }
        })
    }
    
    func didFinishSecondVC(_ controller: UIViewController) {
        if let controller = controller as? TakePhotoDocument {
            self.passRequest.childPhoto = controller.pickedImage
            
            if self.passRequest.childPhoto != nil {
                self.photoIndicator.isHidden = false
            }
        }
    }
}

extension PassRequestViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textFieldParentFio {
            self.textFieldParentPhone.becomeFirstResponder()
        } else if textField == textFieldParentPhone {
            self.textFieldChildFio.becomeFirstResponder()
        } else if textField == textFieldChildFio {
            self.textFieldChildFio.resignFirstResponder()
            if datePickerChildBirthday.isHidden {
                
                toggleDatepicker()
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 3), at: .top, animated: true)
            }
        } else if textField == textFieldTeacherPhone {
            textFieldTeacherPhone.resignFirstResponder()
            send()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == textFieldParentPhone || textField == textFieldTeacherPhone {
            let nsString = NSString(string: textField.text!)
            let newText = nsString.replacingCharacters(in: range, with: string)
            
            textField.text = newText.applyPatternOnNumbers(pattern: "(###)###-##-##", replacmentCharacter: "#")
            
            return false
        }
        
        return true
    }
}
