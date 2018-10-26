//
//  SelectOrganization.swift
//  epass
//
//  Created by Михаил Андреичев on 20/10/2018.
//  Copyright © 2018 MichailAndreichev. All rights reserved.
//

import UIKit

class SelectOrganization: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelNoContent: UILabel!
    
    var refreshControl : UIRefreshControl = UIRefreshControl()
    
    var organizations: [Organization]?
    var filteredOrganizations: [Organization]?
    
    var searchController: UISearchController!
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSearchController()
        
        self.tableView.register(UINib(nibName: "OrganizationCell", bundle: nil),
                                forCellReuseIdentifier: "OrganizationCell")
        self.tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.keyboardDismissMode = .interactive
        self.tableView.addSubview(refreshControl)
        self.refreshControl.addTarget(self,
                                      action: #selector(loadOrganizations),
                                      for: .valueChanged)
        
        let backButton = UIBarButtonItem()
        backButton.title = "Назад"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        labelNoContent.isHidden = true
        
        self.refreshControl.sendActions(for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let indexPath = self.tableView.indexPathForSelectedRow else { return }
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func configureSearchController() {
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск по организациям"
        
        searchController.searchBar.barTintColor = ColorHelper.color(for: .lightGrayColor)
        //searchController.searchBar.tintColor = ColorHelper.color(for: .grayTextColor)
        //searchController.searchBar.backgroundColor = ColorHelper.color(for: .baseGrayColor)
        
        searchController.searchBar.layer.borderColor =          ColorHelper.color(for: .lightGrayColor).cgColor
        searchController.searchBar.layer.borderWidth = 1
        searchController.searchBar.backgroundImage = nil
        
        self.tableView.tableHeaderView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
        //navigationItem.searchController = searchController
        
        let searchField = searchController.searchBar.value(forKey: "searchField") as! UITextField
        searchField.font = UIFont.systemFont(ofSize: 17)
        
        searchController.searchBar.setValue("Отмена", forKey: "_cancelButtonText")
    }
    
    @objc func loadOrganizations() {
        self.view.startShowingActivityIndicator()
        self.labelNoContent.isHidden = true
        
        OrganizationsService.loadOrganizations() {
            result in
            
            self.view.stopShowingActivityIndicator()
            self.refreshControl.endRefreshing()
            
            if result.error != nil {
                self.showError(result.error!.localizedDescription)
                self.labelNoContent.text = "Произошла ошибка сети. Проверьте подключение и повторите попытку."
                self.labelNoContent.isHidden = false
                return
            }
            
            guard result.organizations != nil else {
                self.labelNoContent.text = "Произошла ошибка."
                self.labelNoContent.isHidden = false
                return
            }
            
            self.organizations = result.organizations
            
            self.reloadTableView()
        }
    }
    
    func reloadTableView() {
        if self.organizations?.count == 0 {
            labelNoContent.text = "Нет организаций"
            labelNoContent.isHidden = false
            tableView.isHidden = true
        } else {
            labelNoContent.isHidden = true
            tableView.isHidden = false
        }
        
        self.tableView.reloadData()
    }
}

extension SelectOrganization: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "NewPass", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredOrganizations?.count ?? 0
        } else {
            return organizations?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Выберите организацию, в которую нужно получить пропуск"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrganizationCell", for: indexPath) as! OrganizationCell
        
        var organization: Organization?
        if isFiltering() {
            organization = filteredOrganizations?[indexPath.row]
        } else {
            organization = organizations?[indexPath.row]
        }
        
        cell.labelOrganizationName.text = organization?.name
        cell.imageViewOrganizationType.image = organization?.type?.image
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextVc = segue.destination as? PassRequestViewController {
            
            guard let indexPath = self.tableView.indexPathForSelectedRow else { return }
            
            var organization: Organization?
            if isFiltering() {
                organization = filteredOrganizations?[indexPath.row]
            } else {
                organization = organizations?[indexPath.row]
            }
            
            nextVc.passRequest.organization = organization
        }
        
        self.searchController.dismiss(animated: true, completion: nil)
    }
}

extension SelectOrganization: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text!
        
        filteredOrganizations = organizations?.filter({( item : Organization) -> Bool in
            guard let name = item.name else { return false }
            return name.lowercased().contains(searchString.lowercased())
        })
        
        tableView.reloadData()
    }
}
