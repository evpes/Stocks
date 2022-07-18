//
//  StockDetailsVC.swift
//  Stocks
//
//  Created by evpes on 09.07.2022.
//

import UIKit

class StockDetailsVC: UIViewController {
    // MARK: - Props
    
    private let symbol: String
    private let companyName: String
    private var candleStickData: [CandleStick]
    
    // MARK: - Init
    
    init(symbol: String, companyName: String, candleStickData: [CandleStick] = []) {
        self.symbol = symbol
        self.companyName = companyName
        self.candleStickData = candleStickData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        // Do any additional setup after loading the view.
    }
        

}
