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
    var delegate: HandleLineSelectedDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = SearchViewModel(self)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let line = searchController.searchBar.text ?? ""
        viewModel.updateQuery(line)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellViewModel = viewModel.getCellViewModel(indexPath)
        viewModel.updateQuery(cellViewModel.line)
        delegate?.onLineSelected(line: cellViewModel.line)
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as? ResultTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ResultTableViewCell.")
        }
        
        let cellViewModel = viewModel.getCellViewModel(indexPath)
        cell.titleLabel.text = cellViewModel.title
        cell.delayLabel.text = cellViewModel.delay
        cell.fromLabel.text = cellViewModel.from
        cell.toLabel.text = cellViewModel.to
        return cell
    }
    
    func updateView() {
        self.tableView.reloadData()
    }
    
}
