//
//  StockDetailsVC.swift
//  Stocks
//
//  Created by evpes on 09.07.2022.
//

import UIKit
import SafariServices

/// VC to show stock details
final class StockDetailsVC: UIViewController {
    // MARK: - Props
    
    /// Stock symbol
    private let symbol: String
    /// Company name
    private let companyName: String
    /// Collection of data
    private var candleStickData: [CandleStick]
    
    /// Primary view
    private let tableView: UITableView = {
       let table = UITableView()
        table.register(NewsHeaderView.self, forHeaderFooterViewReuseIdentifier: NewsHeaderView.identifier)
        table.register(NewsStoryCell.self, forCellReuseIdentifier: NewsStoryCell.identifier)
        return table
    }()
    
    /// Collection of news stories
    private var stories: [NewsStory] = []
    
    /// Company metrics
    private var metrics: Metrics?
    
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
        title = companyName
        setUpCloseButton()
        setUpTable()
        fetchFinancialData()
        fetchNews()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // MARK: - Private
    
    /// Sets up tableView
    private func setUpTable() {
        view.addSubviews(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: (view.width * 0.7) + 100) )
    }
    
    /// Fetch financial metrics
    private func fetchFinancialData() {
        let group = DispatchGroup()
        if candleStickData.isEmpty {
            group.enter()
            APICaller.shared.marketData(for: symbol) { [weak self] result in
                defer {
                    group.leave()
                }
                
                switch result {
                case .success(let response):
                    self?.candleStickData = response.candleSticks
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        group.enter()
        APICaller.shared.financialMetrics(for: symbol) { [weak self] result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let response):
                let metrics = response.metric
                self?.metrics = metrics
            case .failure(let error):
                print(error)
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            print("\n\nrender chart 1\n\n")
            self?.renderChart()
        }
        
    }
    
    /// Render chart and metrics
    private func renderChart() {
        print("\n\nrender chart 2\n\n")
        let headerView = StockDetailHeaderView(frame: CGRect(x: 0, y: 0, width: view.width, height: (view.width * 0.7) + 100))
        var viewModels = [MetricCell.ViewModel]()
        if let metrics = metrics {
            viewModels.append(.init(name: "52W High", value: "\(metrics.annualWeekHigh)"))
            viewModels.append(.init(name: "52W Low", value: "\(metrics.annualWeekLow)"))
            viewModels.append(.init(name: "52W Return", value: "\(metrics.annualWeekPriceReturnDaily)"))
            viewModels.append(.init(name: "Beta", value: "\(metrics.beta)"))
            viewModels.append(.init(name: "10D Vol.", value: "\(metrics.tenDayAverageTradingVolume)"))
        }
        let change = getChangePercentage(for: candleStickData)
        headerView.configure(chartViewModel: .init(data: candleStickData.reversed().map { $0.close}, showLegend: false, showAxis: true, fillColor: change < 0 ? .systemRed : .systemGreen), metricViewModels: viewModels)
        tableView.tableHeaderView = headerView
    }
    
    /// Get change percentage
    /// - Parameter data: Symbol of company
    /// - Returns: Collection of data
    private func getChangePercentage(for data: [CandleStick]) -> Double {
        let latestDate = data[0].date
        
        guard let latestClose = data.first?.close,
              let priorClose = data.first(where: { !Calendar.current.isDate($0.date, inSameDayAs: latestDate)})?.close
        else {
            return 0
        }
        
        return (latestClose/priorClose - 1)
    }
    
    /// Fetch news for current company
    private func fetchNews() {
        APICaller.shared.news(for: .company(symbol: symbol)) { [weak self] res in
            switch res {
            case .success(let stories):
                DispatchQueue.main.async {
                    self?.stories = stories
                    self?.tableView.reloadData()
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
    /// Sets up close button
    private func setUpCloseButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
    }
    
    /// Handle close button tap
    @objc private func didTapClose() {
        dismiss(animated: true)
    }
        

}

// MARK: - TableView

extension StockDetailsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsStoryCell.identifier, for: indexPath) as? NewsStoryCell else {
            fatalError()
        }
        cell.configure(with: .init(model: stories[indexPath.row]))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NewsStoryCell.preferredHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: NewsHeaderView.identifier) as? NewsHeaderView else {
            fatalError()
        }
        header.delegate = self
        header.configure(with: .init(title: symbol.uppercased(), shouldShowAddButton: !PersistenceManager.shared.watchlistContains(symbol)))
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return NewsHeaderView.preferredHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let url = URL(string: stories[indexPath.row].url) else { return }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
}

// MARK: - NewsHeaderViewDelegate

extension StockDetailsVC: NewsHeaderViewDelegate {
    func newsHeaderViewDidTapButton(_ headerView: NewsHeaderView) {
        headerView.button.isHidden = true
        PersistenceManager.shared.addToWatchlist(symbol: symbol, companyName: companyName)
        
        let alert = UIAlertController(title: "Added to Watchlist", message: "You've added \(companyName)  to your watchlist", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    
        
}
