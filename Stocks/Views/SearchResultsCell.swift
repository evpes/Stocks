//
//  SearchResultsCell.swift
//  Stocks
//
//  Created by evpes on 10.07.2022.
//

import UIKit

/// Tableview cell for search result
final class SearchResultsCell: UITableViewCell {
    /// Identifier for cell
    static let identifier = "SearchResultsCell"
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
