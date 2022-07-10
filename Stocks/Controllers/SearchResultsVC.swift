//
//  SearchResultsVC.swift
//  Stocks
//
//  Created by evpes on 09.07.2022.
//

import UIKit

protocol SearchResultsVCDelegate: AnyObject {
    func searchResultsVCDidSelect(searchResult: SearchResult)
}

class SearchResultsVC: UIViewController {
    
    weak var delegate: SearchResultsVCDelegate?
    
    private var results: [SearchResult] = []
    
    private let tableView: UITableView = {
        let table = UITableView()
        //Register a cell
        table.register(SearchResultsCell.self, forCellReuseIdentifier: SearchResultsCell.identifier)
        table.isHidden = true
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpTable()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func setUpTable() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    public func update(with results: [SearchResult]) {
        self.results = results
        tableView.isHidden = results.isEmpty
        self.tableView.reloadData()
    }
    

}

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


