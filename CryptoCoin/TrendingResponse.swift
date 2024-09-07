//
//  TrendingResponse.swift
//  CryptoCoin
//
//  Created by 조규연 on 9/8/24.
//

import Foundation

struct TrendingResponse: Decodable {
    let coins: [TrendingCoin]
    let nfts: [TrendingNFTItem]
}

struct TrendingCoin: Decodable, Hashable {
    let item: TrendingCoinItem
}

struct TrendingCoinItem: Decodable, Hashable {
    let id: String
    let name: String
    let symbol: String
    let small: String
    let data: TrendingCoinData
    
    var capitalSymbol: String {
        symbol.uppercased()
    }
}

struct TrendingCoinData: Decodable, Hashable {
    let price: Double
    let priceChangePercentage24h: TrendingPriceChange
    
    private enum CodingKeys: String, CodingKey {
        case price
        case priceChangePercentage24h = "price_change_percentage_24h"
    }
}

struct TrendingPriceChange: Decodable, Hashable {
    let krw: Double
    
    var priceChange: String {
        let result = krw.isLess(than: 0) ? krw.formatted(.number.precision(.fractionLength(2))) + "%" : "+" + krw.formatted(.number.precision(.fractionLength(2))) + "%"
        return result
    }
}

struct TrendingNFTItem: Decodable, Hashable {
    let id: String
    let name: String
    let symbol: String
    let thumb: String
    let data: TrendingNFTData
    
    var capitalSymbol: String {
        symbol.uppercased()
    }
}

struct TrendingNFTData: Decodable, Hashable {
    let floorPrice: String
    let floorPriceInUsd24hPercentageChange: String
    
    var priceChange: String {
        let result = Double(floorPriceInUsd24hPercentageChange)!.isLess(than: 0) ? Double(floorPriceInUsd24hPercentageChange)!.formatted(.number.precision(.fractionLength(2))) + "%" : "+" + Double(floorPriceInUsd24hPercentageChange)!.formatted(.number.precision(.fractionLength(2))) + "%"
        return result
    }
    
    private enum CodingKeys: String, CodingKey {
        case floorPrice = "floor_price"
        case floorPriceInUsd24hPercentageChange = "floor_price_in_usd_24h_percentage_change"
    }
}
