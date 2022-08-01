//
//  StocksTests.swift
//  StocksTests
//
//  Created by evpes on 31.07.2022.
//

@testable import Stocks

import XCTest

class StocksTests: XCTestCase {

    func testCandleStickDataConversion() {
        let doubles: [Double] = Array(repeating: 12.2, count: 10)
        var timestamps: [TimeInterval] = []
        for i in 0..<10 {
            let interval = Date().addingTimeInterval(3600 * TimeInterval(i)).timeIntervalSince1970
            timestamps.append(interval)
        }
        
        timestamps.shuffle()
        
        let marketData = MarketDataResponse(open: doubles, close: doubles, high: doubles, low: doubles, status: "success", timestamps: timestamps)
        
        let candleSticks = marketData.candleSticks
        XCTAssertEqual(candleSticks.count, marketData.open.count)
        XCTAssertEqual(candleSticks.count, marketData.close.count)
        XCTAssertEqual(candleSticks.count, marketData.high.count)
        XCTAssertEqual(candleSticks.count, marketData.low.count)
        
        //Verify sort
        let dates = candleSticks.map { $0.date }
        for x in 0 ..< dates.count - 1 {
            let current = dates[x]
            let next = dates[x+1]
            XCTAssertTrue(current >= next, "\(current) date should be greater then \(next) date")
        }
    }
    

}
