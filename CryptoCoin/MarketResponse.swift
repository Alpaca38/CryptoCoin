//
//  MarketResponse.swift
//  CryptoCoin
//
//  Created by 조규연 on 9/6/24.
//

import Foundation
import CoreTransferable
import UniformTypeIdentifiers

struct MarketItem: Codable, Hashable, Transferable {
    let id: String
    let name: String
    let symbol: String
    let image: String
    let currentPrice: Double
    let priceChangePercentage24h: Double
    let low24h: Double
    let high24h: Double
    let ath: Double
    let athDate: String
    let atl: Double
    let atlDate: String
    let lastUpdated: String
    let sparklineIn7d: SparkLine?
    
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .marketItem)
    }
    
    var priceChange: String {
        let result = priceChangePercentage24h.isLess(than: 0) ? priceChangePercentage24h.formatted(.number.precision(.fractionLength(2))) + "%" : "+" + priceChangePercentage24h.formatted(.number.precision(.fractionLength(2))) + "%"
        return result
    }
    
    var capitalSymbol: String {
        symbol.uppercased()
    }
    
    var lastUpdatedText: String {
        DateFormatManager.shared.toDateTime(updatedAt: lastUpdated) + " 업데이트"
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, name, symbol, image
        case currentPrice = "current_price"
        case priceChangePercentage24h = "price_change_percentage_24h"
        case low24h = "low_24h"
        case high24h = "high_24h"
        case ath
        case athDate = "ath_date"
        case atl
        case atlDate = "atl_date"
        case lastUpdated = "last_updated"
        case sparklineIn7d = "sparkline_in_7d"
    }
}

typealias MarketResponse = [MarketItem]

struct SparkLine: Codable, Hashable {
    let price: [Double]
    
    var lowPrice: Double {
        price.min() ?? 0
    }
    
    var highPrice: Double {
        price.max() ?? 0
    }
}

extension UTType {
    static let marketItem = UTType(exportedAs: "com.jo.marketItem")
}
