//
//  PersistenceManager.swift
//  Stocks
//
//  Created by evpes on 09.07.2022.
//

import Foundation

final class PersistenceManager {
    static let shared = PersistenceManager()
    
    private let userDefaults: UserDefaults = .standard
    
    private struct Constants {
        
    }
    
    private init() {}
    
    //MARK: - Public
    
    public var watchlist: [String] {
        return []
    }
    
    public func addToWatchlist() {
        
    }
    
    public func removeFromWatchlist() {
        
    }
    
    //MARK: - Private
    
    private var hasOnboarded: Bool {
        return false
    }
}
