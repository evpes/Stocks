//
//  SearchResultsCell.swift
//  Stocks
//
//  Created by evpes on 10.07.2022.
//

import UIKit

class SearchResultsCell: UITableViewCell {
    static let identifier = "SearchResultsCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
