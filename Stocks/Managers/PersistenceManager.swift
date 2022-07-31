//
//  PersistenceManager.swift
//  Stocks
//
//  Created by evpes on 09.07.2022.
//

import Foundation

/// Object to manage saved caches
final class PersistenceManager {
    /// Singleton
    static let shared = PersistenceManager()
    
    /// Reference to user defaults
    private let userDefaults: UserDefaults = .standard
    
    /// Constants
    private struct Constants {
        static let onboardedKey = "hasOnboarded"
        static let watchlistKey = "watchlist"
    }
    
    /// Private constructor
    private init() {}
    
    //MARK: - Public
    
    /// Get user watchlist
    public var watchlist: [String] {
        if !hasOnboarded {
            userDefaults.set(true, forKey: Constants.onboardedKey)
            setUpDefaults()
        }
        print("UD \(userDefaults.stringArray(forKey: Constants.watchlistKey))")
        return userDefaults.stringArray(forKey: Constants.watchlistKey) ?? []
    }
    
    /// Check if watchlist contains item
    /// - Parameter symbol: symbol to check
    /// - Returns: Bool
    public func watchlistContains(_ symbol: String) -> Bool {
        return watchlist.contains(symbol)
    }
    
    /// Add a symbol to watchlist
    /// - Parameters:
    ///   - symbol: Symbol to add
    ///   - companyName: Company name for symbol
    public func addToWatchlist(symbol: String, companyName: String) {
        var current = watchlist
        current.append(symbol)
        userDefaults.set(companyName, forKey: symbol)
        userDefaults.set(current, forKey: Constants.watchlistKey)
        
        NotificationCenter.default.post(name: .didAddToWatchList, object: nil)
        
    }
    
    /// Remove item from watchlist
    /// - Parameter symbol: Symbol to remove
    public func removeFromWatchlist(symbol: String) {
        print("Remove \(symbol)")
        var newList = [String]()
        userDefaults.set(nil, forKey: symbol)
        for item in watchlist where item != symbol {
            newList.append(item)
        }
        print("New list is \(newList)")
        userDefaults.set(newList, forKey: Constants.watchlistKey)
    }
    
    //MARK: - Private
    
    /// Check if user has been onboarded
    private var hasOnboarded: Bool {
        return userDefaults.bool(forKey: Constants.onboardedKey)
    }
    
    /// Set up default watchlist
    private func setUpDefaults() {
        let map: [String: String] = [
            "MSFT": "Microsoft Corporation",
            "GOOG": "Alphabet",
            "AMZN": "Amazon.com, Inc.",
            "SNAP": "Snap Inc."
        ]
        
        let symbols = map.keys.map { $0 }
        userDefaults.set(symbols, forKey: Constants.watchlistKey)
        
        for (symbol, name) in map {
            userDefaults.set(name, forKey: symbol)
        }
    }
}
