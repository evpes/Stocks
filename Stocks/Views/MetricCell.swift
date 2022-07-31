//
//  MetricCell.swift
//  Stocks
//
//  Created by evpes on 19.07.2022.
//

import UIKit

/// Metric table cell
final class MetricCell: UICollectionViewCell {
    /// Cell id
    static let identifier = "MetricCell"
    
    /// Metric tableView cell model
    struct ViewModel {
        let name: String
        let value: String
    }
    
    /// Name label
    private let nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    /// Value label
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        addSubviews(nameLabel, valueLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        valueLabel.sizeToFit()
        nameLabel.sizeToFit()
        nameLabel.frame = CGRect(x: 3, y: 0, width: nameLabel.width, height: contentView.height)
        valueLabel.frame = CGRect(x: nameLabel.right + 3, y: 0, width: valueLabel.width, height: contentView.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        valueLabel.text = nil
    }
    
    /// Configure view
    /// - Parameter viewModel: View ViewModel
    func configure(with viewModel: ViewModel) {
        nameLabel.text = viewModel.name + ":"
        valueLabel.text = viewModel.value
    }
    
    
}
