//
//  WatchListVC.swift
//  Stocks
//
//  Created by evpes on 09.07.2022.
//

import UIKit

class WatchListVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpSearchController()
        setUpTitleView()
    }
    
    //MARK: - Private
    
    private func setUpTitleView() {
        let titleView = UIView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: view.width,
                height: navigationController?.navigationBar.height ?? 100
            )
        )
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: titleView.width-20, height: titleView.height))
        label.text = "Stocks"
        label.font = .systemFont(ofSize: 40, weight: .medium)
        titleView.addSubview(label)
        navigationItem.titleView = titleView
    }
    
    private func setUpSearchController() {
        let resultVC = SearchResultsVC()
        let searchVC = UISearchController(searchResultsController: resultVC)
        searchVC.searchResultsUpdater = self
        navigationItem.searchController = searchVC
    }


}

extension WatchListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text,
              let resultsVC = searchController.searchResultsController as? SearchResultsVC,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        // Optimize to reduce number of searches
        
        // Call API Search
        
        // Update results controller
        
        print(query)
    }
}

