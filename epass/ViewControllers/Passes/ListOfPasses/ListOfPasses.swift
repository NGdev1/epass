//
//  ListOfPasses.swift
//  epass
//
//  Created by Михаил Андреичев on 17/10/2018.
//  Copyright © 2018 MichailAndreichev. All rights reserved.
//

import UIKit
import Lightbox
import SVProgressHUD
import SDWebImage

class ListOfPasses: UIViewController {
    
    var refreshControl : UIRefreshControl = UIRefreshControl()
    
    @IBOutlet weak var barButtonAdd: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var buttonAdd: UIButton!
    
    @IBOutlet weak var imageViewNoContent: UIImageView!
    @IBOutlet weak var labelNoContent: UILabel!
    
    var passes = [Pass]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.buttonAdd.addTarget(self,
                                 action: #selector(self.showListOfOrganizations),
                                 for: .touchUpInside)
        self.barButtonAdd.target = self
        self.barButtonAdd.action = #selector(self.showListOfOrganizations)
        
        self.tableView.register(UINib(nibName: "PassCell", bundle: nil),
                                forCellReuseIdentifier: "PassCell")
        self.tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.addSubview(refreshControl)
        
        imageViewNoContent.isHidden = true
        labelNoContent.isHidden = true
        
        self.refreshControl.addTarget(self,
                                      action: #selector(loadPasses),
                                      for: .valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.refreshControl.sendActions(for: .valueChanged)
    }
    
    @objc func loadPasses() {
        if self.passes.count == 0 {
            self.progressView.startShowingActivityIndicator()
        }
        imageViewNoContent.isHidden = true
        labelNoContent.isHidden = true
        
        let deviceId = Device.getDeviceId()
        PassService.loadPasses(deviceId: deviceId) {
            result in
            
            self.progressView.stopShowingActivityIndicator()
            self.refreshControl.endRefreshing()
            
            if result.error != nil {
                self.labelNoContent.text = "Произошла ошибка сети. Проверьте подключение и повторите попытку."
                self.labelNoContent.isHidden = false
                self.imageViewNoContent.isHidden = false
                self.passes.removeAll()
                self.tableView.reloadData()
                return
            }
            
            guard result.passes != nil else {
                self.labelNoContent.text = "Произошла ошибка."
                self.imageViewNoContent.isHidden = false
                self.labelNoContent.isHidden = false
                self.passes.removeAll()
                self.tableView.reloadData()
                return
            }
            
            self.passes = result.passes ?? [Pass]()
            
            self.reloadTableView()
        }
    }
    
    func reloadTableView() {
        if self.passes.count == 0 {
            self.labelNoContent.text = "Нет пропусков"
            imageViewNoContent.isHidden = false
            labelNoContent.isHidden = false
        } else {
            imageViewNoContent.isHidden = true
            labelNoContent.isHidden = true
        }
        
        self.tableView.reloadData()
    }
    
    @objc func showListOfOrganizations() {
        self.performSegue(withIdentifier: "showListOfOrganizations", sender: self)
    }
}

extension ListOfPasses: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.passes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PassCell", for: indexPath) as! PassCell
        
        cell.labelOrganization.text = passes[indexPath.section].organizationName
        cell.labelStatus.text = passes[indexPath.section].status?.title ?? ""
        cell.labelStatusText.text = passes[indexPath.section].statusText
        cell.labelCabinets.text = passes[indexPath.section].cabinets
        cell.labelClientName.text = passes[indexPath.section].clientName
        cell.labelChildName.text = passes[indexPath.section].childName
        
        if let stringUrl = passes[indexPath.section].clientPhotoUrl {
            let url = URL(string: "http://178.206.224.220:98" + stringUrl)
            cell.imageViewPhoto.sd_setImage(with: url)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        guard let id = passes[indexPath.section].id else {
            return
        }
        
        SVProgressHUD.show()
        
        let _ = APIService.shared().showPass(id: id, deviceId: Device.getDeviceId()) {
            image, error in
            
            SVProgressHUD.dismiss()
            
            if error != nil {
                SVProgressHUD.show(withStatus: "Ошибка сети.")
                return
            }
            
            guard image != nil else {
                SVProgressHUD.show(withStatus: "Ошибка сети.")
                return
            }
            
            let images = [
                LightboxImage(image: image!)
            ]
            
            // Create an instance of LightboxController.
            let controller = LightboxController(images: images)
            
            // Use dynamic background.
            controller.dynamicBackground = true
            controller.footerView.isHidden = true
            
            // Present your controller.
            self.present(controller, animated: true, completion: nil)
            
        }
    }
    
}
