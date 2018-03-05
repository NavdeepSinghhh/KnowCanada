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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        InfoRequestRouter().getSearchResults { (canadaInfo, errorMessage) in
            if let canadaInfo = canadaInfo{
                print("Total elements read = \(canadaInfo.rows.count)")
                print("Title = \(canadaInfo.title)")
            }else{
                print(errorMessage)
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension InfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: InfoCell = tableView.dequeueReusableCell(withIdentifier: infoCellIndentifier, for: indexPath) as! InfoCell
        return cell
    }
}

// MARK: - UITableViewDelegate

extension InfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    
}

