//
//  TrendingView.swift
//  CryptoCoin
//
//  Created by 조규연 on 9/7/24.
//

import SwiftUI

struct TrendingView: View {
    @Binding var likedCoinIDs: [String]
    @State private var favoriteList: MarketResponse = []
    
    var body: some View {
        NavigationView {
            sections()
                .navigationTitle("Crypto Coin")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Image(systemName: "person")
                            .asButton {
                                print("프로필 버튼")
                            }
                    }
                }
        }
        .task {
            do {
                if likedCoinIDs.count < 2 {
                    favoriteList.removeAll()
                } else {
                    let result = try await CoingeckoAPI.shared.getMarketData(ids: likedCoinIDs)
                    favoriteList = result
                }
            } catch {
                print(error)
            }
        }
    }
    
    func sections() -> some View {
        ScrollView {
            LazyVStack(spacing: 40) {
                if favoriteList.count >= 2 {
                    FavoriteSection(list: favoriteList, likedCoinIDs: $likedCoinIDs)
                }
                CoinSection()
                NFTSection()
            }
        }
    }
}

private struct FavoriteSection: View {
    let list: MarketResponse
    @Binding var likedCoinIDs: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("My Favorite")
                .bold()
                .font(.title)
            ScrollView(.horizontal) {
                LazyHStack(spacing: 15) {
                    ForEach(list, id: \.id) { item in
                        NavigationLink {
                            NavigationLazyView(ChartView(likedCoinIDs: $likedCoinIDs, id: item.id))
                        } label: {
                            favoriteItem(item)
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
    
    func favoriteItem(_ item: MarketItem) -> some View {
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
            .scrollIndicators(.hidden)
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
            .scrollIndicators(.hidden)
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
//
//#Preview {
//    TrendingView()
//}
