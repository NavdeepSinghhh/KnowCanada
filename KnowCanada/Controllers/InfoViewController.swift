//
//  InfoViewController.swift
//  KnowCanada
//
//  Created by Navdeep's Mac on 3/3/18.
//  Copyright © 2018 Navdeep. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    // Identifier for Info Cell
    let infoCellIndentifier = "InfoCell"
    
    // MARK: - properties of the VC
    var canadaInfo : CanadaInfo? = nil
    
    // MARK: - private constants to avoid magic numbers
    fileprivate let estimatedRowHeight: CGFloat = 250
    
    // MARK: - View elements inside the View
    @IBOutlet weak var infoTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(self.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TableView view related settings
        infoTableView.allowsSelection = false
        infoTableView.separatorStyle = .none
        infoTableView.addSubview(self.refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // start activity spinner
        self.activityIndicator.startAnimating()
        // Fetch data from the API
        InfoRequestRouter().getSearchResults { result in
            switch result {
            case let .success(canadaInfo):
                self.canadaInfo = canadaInfo
                DispatchQueue.main.async {
                    self.title = canadaInfo.title
                    self.infoTableView.reloadData()
                    self.refreshControl.endRefreshing()
                    self.activityIndicator.stopAnimating()
                }
            // We had handle the error more precisely rather then just printing to console.
            // The specific type of error can generate specific error for the user
            case let .failure(error) : print(error)
            }
        }
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        viewWillAppear(false)
    }
}


// MARK: - UITableViewDataSource

extension InfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let canadaInfo = canadaInfo{
            return canadaInfo.rows.count
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: InfoCell = tableView.dequeueReusableCell(withIdentifier: infoCellIndentifier, for: indexPath) as! InfoCell
        let info: InfoModel = (canadaInfo?.rows[indexPath.row])!
        if let _ = info.title{
            cell.infoModel = info
        }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension InfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height : CGFloat = 200
        let info: InfoModel = (canadaInfo?.rows[indexPath.row])!
        // TODO: Fix the magic numbers
        if let title = info.title{
            height += title.height(withConstrainedWidth: self.infoTableView.frame.width, font: UIFont.preferredFont(forTextStyle: .headline))
        }
        if let description = info.description{
            height += description.height(withConstrainedWidth: self.infoTableView.frame.width, font: UIFont.preferredFont(forTextStyle: .footnote))
        }
        return height
    }
}

