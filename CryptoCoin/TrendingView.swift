//
//  TrendingView.swift
//  CryptoCoin
//
//  Created by 조규연 on 9/7/24.
//

import SwiftUI

struct TrendingView: View {
    var body: some View {
        NavigationView {
            sections()
                .navigationTitle("Crypto Coin")
        }
    }
    
    func sections() -> some View {
        ScrollView {
            LazyVStack(spacing: 40) {
                FavoriteSection()
                CoinSection()
                NFTSection()
            }
        }
    }
}

private struct FavoriteSection: View {
    let item = MarketItem(id: "a", name: "Bitcoin", symbol: "btc", image: "", currentPrice: 0, priceChangePercentage24h: 0, low24h: 0, high24h: 0, ath: 0, athDate: "", atl: 0, atlDate: "", lastUpdated: "", sparklineIn7d: nil)
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("My Favorite")
                .bold()
                .font(.title)
            ScrollView(.horizontal) {
                LazyHStack(spacing: 15) {
                    favoriteItem()
                    favoriteItem()
                    favoriteItem()
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
    
    func favoriteItem() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25.0)
                .fill(.gray.opacity(0.2))
                .frame(width: 200, height: 160)
            VStack {
                CoinSymbolView(item: item)
                Spacer()
                VStack(alignment: .leading) {
                    Text(item.currentPrice.formatted(.currency(code: "krw")))
                        .bold()
                        .foregroundStyle(.black)
                    Text(item.priceChange)
                        .font(.caption)
                        .bold()
                        .foregroundStyle(item.priceChangePercentage24h.isLess(than: 0) ? .blue : .red)
                        .padding(.vertical, 4)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
        }
    }
}

private struct CoinSection: View {
    let item = MarketItem(id: "a", name: "Bitcoin", symbol: "btc", image: "", currentPrice: 0, priceChangePercentage24h: 0, low24h: 0, high24h: 0, ath: 0, athDate: "", atl: 0, atlDate: "", lastUpdated: "", sparklineIn7d: nil)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Top15 Coin")
                .bold()
                .font(.title)
            ScrollView(.horizontal) {
                CoinGridView()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

private struct NFTSection: View {
    let item = MarketItem(id: "a", name: "Bitcoin", symbol: "btc", image: "", currentPrice: 0, priceChangePercentage24h: 0, low24h: 0, high24h: 0, ath: 0, athDate: "", atl: 0, atlDate: "", lastUpdated: "", sparklineIn7d: nil)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Top7 NFT")
                .bold()
                .font(.title)
            ScrollView(.horizontal) {
                CoinGridView()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

struct CoinGridView: View {
    let item = MarketItem(id: "a", name: "Bitcoin", symbol: "btc", image: "", currentPrice: 0, priceChangePercentage24h: 0, low24h: 0, high24h: 0, ath: 0, athDate: "", atl: 0, atlDate: "", lastUpdated: "", sparklineIn7d: nil)
    
    var row: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    var body: some View {
        LazyHGrid(rows: row, spacing: 20, content: {
            ForEach(0..<15) { item in
                rowView()
            }
        })
    }
    
    func rowView() -> some View {
        HStack {
            Text("1")
                .bold()
                .font(.title2)
            CoinSymbolView(item: item)
                .padding(.trailing, 100)
            VStack(alignment: .trailing) {
                Text(item.currentPrice.formatted(.currency(code: "krw")))
                    .bold()
                    .foregroundStyle(.black)
                Text(item.priceChange)
                    .font(.caption)
                    .bold()
                    .foregroundStyle(item.priceChangePercentage24h.isLess(than: 0) ? .blue : .red)
            }
        }
        .padding(.vertical, 10)
    }
}

#Preview {
    TrendingView()
}
