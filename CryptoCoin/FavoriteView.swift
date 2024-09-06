//
//  FavoriteView.swift
//  CryptoCoin
//
//  Created by 조규연 on 9/6/24.
//

import SwiftUI

struct FavoriteView: View {
    @Binding var likedCoinIDs: [String]
    @State private var list: MarketResponse = [
        MarketItem(id: "1", name: "", symbol: "", image: "", currentPrice: 0, priceChangePercentage24h: 0, low24h: 0, high24h: 0, ath: 0, athDate: "", atl: 0, atlDate: "", lastUpdated: "", sparklineIn7d: SparkLine(price: [])),
        MarketItem(id: "2", name: "", symbol: "", image: "", currentPrice: 0, priceChangePercentage24h: 0, low24h: 0, high24h: 0, ath: 0, athDate: "", atl: 0, atlDate: "", lastUpdated: "", sparklineIn7d: SparkLine(price: [])),
        MarketItem(id: "3", name: "", symbol: "", image: "", currentPrice: 0, priceChangePercentage24h: 0, low24h: 0, high24h: 0, ath: 0, athDate: "", atl: 0, atlDate: "", lastUpdated: "", sparklineIn7d: SparkLine(price: []))
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                FavoriteCoinGridView(list: $list)
                    .padding()
            }
            .navigationTitle("Favorite Coin")
        }
    }
}

private struct FavoriteCoinGridView: View {
    @Binding var list: MarketResponse
    
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    var body: some View {
        LazyVGrid(columns: columns, content: {
            ForEach(list, id: \.id) { item in
                coinItem(item)
            }
        })
    }
    
    func coinItem(_ item: MarketItem) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25.0)
                .fill(.white)
                .frame(height: 150)
                .shadow(radius: 5)
            VStack {
                HStack {
                    Image(systemName: "person")
                    
                    VStack(alignment: .leading) {
                        Text("bitcoin")
                            .bold()
                        Text("BTC")
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                    Spacer()
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text(52413424.formatted(.currency(code: "krw")))
                        .bold()
                    Text(String(0.64) + "%")
                        .font(.caption)
                        .bold()
                        .foregroundStyle(.red)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 10)
                        .background(.red.opacity(0.5))
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding()
        }
    }
}
//
//#Preview {
//    FavoriteView()
//}
