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

class ResultTableViewController: UITableViewController, UISearchResultsUpdating, ResultSearchDelegate {
    
    var viewModel: SearchViewModel!
    var delegate: HandleLineSelectedDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = SearchViewModel(self)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let line = searchController.searchBar.text else {
            return
        }
        
        if line.isEmpty {
            delegate?.resetSelection()
        }
        viewModel.updateQuery(query: line)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rows
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellViewModel = viewModel.getCellViewModel(indexPath)
        
        if cellViewModel.isSummary {
            viewModel.updateQuery(query: cellViewModel.line)
            delegate?.onSelection(line: cellViewModel.line)
        } else {
            delegate?.onSelection(id: cellViewModel.id)
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellViewModel = viewModel.getCellViewModel(indexPath)
        
        if cellViewModel.isSummary == true  {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "overviewCell", for: indexPath) as? OverviewTableViewCell  else {
                fatalError("The dequeued cell is not an instance of OverviewTableViewCell.")
            }
            cell.vehicleLabel.text = "Pokaż wszystkie pojazdy linii \(cellViewModel.line)"
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as? ResultTableViewCell  else {
                fatalError("The dequeued cell is not an instance of ResultTableViewCell.")
            }
            
            cell.titleLabel.text = cellViewModel.title
            cell.delayLabel.text = cellViewModel.delay
            cell.delayTextLabel.text = cellViewModel.delayText
            cell.minutesLabel.text = cellViewModel.minutes
            cell.fromLabel.text = cellViewModel.from
            cell.toLabel.text = cellViewModel.to
            return cell
        }
    }
    
    func updateView() {
        self.tableView.reloadData()
    }
    
}
