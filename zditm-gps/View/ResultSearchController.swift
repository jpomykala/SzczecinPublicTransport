//
//  ResultSearchController.swift
//  zditm-gps
//
//  Created by Jakub Pomykała on 9/24/17.
//  Copyright © 2017 Jakub Pomykała. All rights reserved.
//

import Foundation
import UIKit
import MapKit

protocol ResultSearchDelegate {
    func updateView()
}

class ResultSearchController: UITableViewController, UISearchResultsUpdating, ResultSearchDelegate {
 
    var viewModel: SearchViewModel!
    var mapView: MKMapView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = SearchViewModel(self)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchBarText = searchController.searchBar.text else { return }
        viewModel.updateQuery(searchBarText)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as? ResultTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ResultTableViewCell.")
        }
        
        cell.titleLabel.text = viewModel.getTitle(indexPath: indexPath)
        cell.delayLabel.text = viewModel.getDelay(indexPath: indexPath)
        cell.fromLabel.text = viewModel.getFrom(indexPath: indexPath)
        cell.toLabel.text = viewModel.getTo(indexPath: indexPath)
        
        return cell
    }
    
    func updateView() {
        self.tableView.reloadData()
    }
    
}
