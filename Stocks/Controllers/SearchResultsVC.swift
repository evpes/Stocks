//
//  SearchResultsVC.swift
//  Stocks
//
//  Created by evpes on 09.07.2022.
//

import UIKit

/// Delegate for search results
protocol SearchResultsVCDelegate: AnyObject {
    /// Notify delegate of selection
    /// - Parameter searchResult: Result that was picked
    func searchResultsVCDidSelect(searchResult: SearchResult)
}

/// VC to show search results
class SearchResultsVC: UIViewController {
    
    /// Delegate to get events
    weak var delegate: SearchResultsVCDelegate?
    
    /// Collection of results
    private var results: [SearchResult] = []
    
    /// Primary view
    private let tableView: UITableView = {
        let table = UITableView()
        //Register a cell
        table.register(SearchResultsCell.self, forCellReuseIdentifier: SearchResultsCell.identifier)
        table.isHidden = true
        return table
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpTable()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // MARK: - Private
    
    /// Sets up tableView
    private func setUpTable() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Public
    
    /// Update results on VC
    /// - Parameter results: Collection of new results
    public func update(with results: [SearchResult]) {
        self.results = results
        tableView.isHidden = results.isEmpty
        self.tableView.reloadData()
    }
    

}

// MARK: - TableView

extension SearchResultsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultsCell.identifier, for: indexPath)
        
        let model = results[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = model.displaySymbol
        content.secondaryText = model.description
        cell.contentConfiguration = content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = results[indexPath.row]
        delegate?.searchResultsVCDidSelect(searchResult: model)
    }
}


