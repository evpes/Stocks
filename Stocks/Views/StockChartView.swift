//
//  StockChartView.swift
//  Stocks
//
//  Created by evpes on 16.07.2022.
//

import Charts
import UIKit

/// View to show a chart
class StockChartView: UIView {
    
    /// Chart view viewModel
    struct ViewModel {
        let data: [Double]
        let showLegend: Bool
        let showAxis: Bool
        let fillColor: UIColor
    }
    
    /// Chart view
    private let chartView: LineChartView = {
        let chartView = LineChartView()
        chartView.pinchZoomEnabled = false
        chartView.setScaleEnabled(true)
        chartView.xAxis.enabled = false
        chartView.drawGridBackgroundEnabled = false
        chartView.legend.enabled = false
        chartView.leftAxis.enabled = false
        chartView.rightAxis.enabled = false
        return chartView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(chartView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        chartView.frame = bounds
    }
    
    /// reset chart view
    func reset() {
        chartView.data = nil
    }
    
    /// Configure view
    /// - Parameter viewModel: View ViewModel
    func configure(with viewModel: ViewModel) {
        var entries = [ChartDataEntry]()
        for (index, value) in viewModel.data.enumerated() {
            entries.append(.init(x: Double(index), y: value))
        }
        
        chartView.rightAxis.enabled = viewModel.showAxis
        chartView.legend.enabled = viewModel.showLegend
        
        let dataSet = LineChartDataSet(entries: entries, label: "7 Days")
        dataSet.fillColor = viewModel.fillColor
        dataSet.drawFilledEnabled = true
        dataSet.drawIconsEnabled = false
        dataSet.drawValuesEnabled = false
        dataSet.drawCirclesEnabled = false
        let data = LineChartData(dataSet: dataSet)
        chartView.data = data
    }
    
}
