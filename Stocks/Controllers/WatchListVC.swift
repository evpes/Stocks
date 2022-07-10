//
//  WatchListVC.swift
//  Stocks
//
//  Created by evpes on 09.07.2022.
//

import UIKit

class WatchListVC: UIViewController {
    
    private var searchTimer: Timer?

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
        resultVC.delegate = self
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
        // Reset timer
        
        searchTimer?.invalidate()
        
        // Kick off new timer
        // Optimize to reduce number of searches
        
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { _ in
            APICaller.shared.search(query: query) { result in
                switch result {
                case .success(let response):
                    DispatchQueue.main.async { resultsVC.update(with: response.result) }
                case .failure(let error):
                    DispatchQueue.main.async { resultsVC.update(with: []) }
                    print(error.localizedDescription)
                }
            }
        })
                                        
    }
}

extension WatchListVC: SearchResultsVCDelegate {
    func searchResultsVCDidSelect(searchResult: SearchResult) {
        //Present stock details for given selection
        navigationItem.searchController?.searchBar.resignFirstResponder()
        let vc = StockDetailsVC()
        let navVC = UINavigationController(rootViewController: vc)
        vc.title = searchResult.description
        present(navVC, animated: true)
    }
}

