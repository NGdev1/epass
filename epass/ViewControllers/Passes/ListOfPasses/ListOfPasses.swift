//
//  ListOfPasses.swift
//  epass
//
//  Created by Михаил Андреичев on 17/10/2018.
//  Copyright © 2018 MichailAndreichev. All rights reserved.
//

import UIKit

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
        self.progressView.startShowingActivityIndicator()
        imageViewNoContent.isHidden = true
        labelNoContent.isHidden = true
        
        let deviceId = Device.getDeviceId()
        PassService.loadPasses(deviceId: deviceId) {
            result in

            self.progressView.stopShowingActivityIndicator()
            self.refreshControl.endRefreshing()

            if result.error != nil {
                self.showError(result.error!.localizedDescription)
                self.labelNoContent.text = "Произошла ошибка сети. Проверьте подключение и повторите попытку."
                self.labelNoContent.isHidden = false
                self.imageViewNoContent.isHidden = false
                return
            }

            guard result.passes != nil else {
                self.labelNoContent.text = "Произошла ошибка."
                self.imageViewNoContent.isHidden = false
                self.labelNoContent.isHidden = false
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
        return self.passes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PassCell", for: indexPath) as! PassCell
        
        cell.labelStatus.text = passes[indexPath.row].status?.title
        cell.labelStatusText.text = passes[indexPath.row].statusText
        cell.labelCabinets.text = passes[indexPath.row].cabinets
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 122
    }
    
}
