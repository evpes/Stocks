//
//  APICaller.swift
//  Stocks
//
//  Created by evpes on 09.07.2022.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    private struct Constants {
        static let apiKey = "cb5b1caad3ib3j4qfdl0"
        static let sandboxApiKey = "sandbox_cb5b1caad3ib3j4qfdlg"
        static let baseUrl = "https://finnhub.io/api/v1/"
        static let day: TimeInterval = 3600 * 24
    }
    
    private init() {}
    
    //MARK: - Public
    
    // get stock info
    
    public func search(query: String, completion: @escaping (Result<SearchResponse, Error>) -> Void) {
        guard let safeQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        request(
            url: url(for: .search, queryParams: ["q": safeQuery]),
            expecting: SearchResponse.self,
            completion: completion
        )
    }
    
    // search stocks
    
    public func news(for type: NewsVC.NewsType, completion: @escaping (Result<[NewsStory], Error>) -> Void) {
        switch type {
        case .topStories:
            request(
                url: url(for: .topStories, queryParams: ["category":"general"]),
                expecting: [NewsStory].self,
                completion: completion
            )
        case .company(let symbol):
            let today = Date()
            let oneMonthBack = today.addingTimeInterval(-(Constants.day * 7))
            request(
                url: url(for: .companyNews,
                         queryParams: [
                            "symbol": symbol,
                            "from": DateFormatter.newsDateFormatter.string(from: oneMonthBack),
                            "to": DateFormatter.newsDateFormatter.string(from: today)
                         ]
                        ),
                expecting: [NewsStory].self,
                completion: completion
            )
        }
    }
    
    public func marketData(for symbol: String, numberOfDays: TimeInterval = 3, completion: @escaping (Result<MarketDataResponse, Error>) -> Void) {
        let today = Date()
        let prior = today.addingTimeInterval(-(Constants.day * numberOfDays))
        
        request(url: url(for: .marketData, queryParams: [
            "symbol": symbol,
            "resolution": "1",
            "from": "\(Int(prior.timeIntervalSince1970))",
            "to": "\(Int(today.timeIntervalSince1970))"
        ]),
                expecting: MarketDataResponse.self,
                completion: completion)
    }
    
    //MARK: - Private
    
    private enum Endpoint: String {
        case search
        case topStories = "news"
        case companyNews = "company-news"
        case marketData = "stock/candle"
    }
    
    private enum APIError: Error {
        case noDataReturned
        case invalidURL
    }
    
    private func url(for endpoint: Endpoint, queryParams: [String: String] = [:]) -> URL? {
        var urlString = Constants.baseUrl + endpoint.rawValue
        
        var queryItems = [URLQueryItem]()
        // Add any parameters
        for (key, value) in queryParams {
            queryItems.append(.init(name: key, value: value))
        }
        
        // Add token
        queryItems.append(.init(name: "token", value: Constants.apiKey))
        
        // Convert query items to suffix string
        
        urlString += "?" + queryItems.map { "\($0.name)=\($0.value ?? "")" }.joined(separator: "&")
        
        print(urlString)
        
        return URL(string: urlString)
    }
    
    private func request<T: Codable>(url: URL?, expecting: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = url else {
            //Invalid URL
            completion(.failure(APIError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(APIError.noDataReturned))
                }
                return
            }
            
            do {
                let result = try JSONDecoder().decode(expecting, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
