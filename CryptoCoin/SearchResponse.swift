//
//  SearchResponse.swift
//  CryptoCoin
//
//  Created by 조규연 on 9/6/24.
//

import Foundation

struct SearchResponse: Decodable {
    let coins: Coins
}

struct Coin: Decodable {
    let id: String
    let name: String
    let symbol: String
    let thumb: String
}

typealias Coins = [Coin]
