//
//  ResultSearchController.swift
//  zditm-gps
//
//  Created by Jakub Pomykała on 9/24/17.
//  Copyright © 2017 Jakub Pomykała. All rights reserved.
//

import Foundation
import UIKit

class ResultSearchController: UITableViewController {
 
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension ResultSearchController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print(searchController.searchBar.text ?? "nic")
    }
}
