//
//  TrendingView.swift
//  CryptoCoin
//
//  Created by 조규연 on 9/7/24.
//

import SwiftUI

struct TrendingView: View {
    @Binding var index: Int
    @Binding var likedCoinIDs: [String]
    @State private var favoriteList: MarketResponse = []
    @State private var trendingList: TrendingResponse = TrendingResponse(coins: [], nfts: [])
    
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
            
            do {
                let result = try await CoingeckoAPI.shared.getTrendingCrypto()
                trendingList = result
            } catch {
                print(error)
            }
        }
    }
    
    func sections() -> some View {
        ScrollView {
            LazyVStack(spacing: 40) {
                if favoriteList.count >= 2 {
                    FavoriteSection(list: favoriteList, likedCoinIDs: $likedCoinIDs, index: $index)
                }
                CoinSection(list: trendingList, likedCoinIDs: $likedCoinIDs)
                NFTSection(list: trendingList, likedCoinIDs: $likedCoinIDs)
            }
        }
    }
}

private struct FavoriteSection: View {
    let list: MarketResponse
    @Binding var likedCoinIDs: [String]
    @Binding var index: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("My Favorite")
                .bold()
                .font(.title)
            if #available(iOS 17.0, *) {
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 15) {
                        ForEach(Array(list.reversed().enumerated()), id: \.element) { index, item in
                            if index < 3 {
                                NavigationLink {
                                    NavigationLazyView(ChartView(likedCoinIDs: $likedCoinIDs, id: item.id))
                                } label: {
                                    favoriteItem(item)
                                }
                            }
                        }
                        moreItem()
                    }
                    .scrollTargetLayout()
                }
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.viewAligned)
            } else {
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 15) {
                        ForEach(Array(list.reversed().enumerated()), id: \.element) { index, item in
                            if index < 3 {
                                NavigationLink {
                                    NavigationLazyView(ChartView(likedCoinIDs: $likedCoinIDs, id: item.id))
                                } label: {
                                    favoriteItem(item)
                                }
                            }
                        }
                        moreItem()
                    }
                }
                .scrollIndicators(.hidden)
            }
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
    
    func moreItem() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25.0)
                .fill(.gray.opacity(0.2))
                .frame(width: 200, height: 160)
            Text("더보기")
        }
        .asButton {
            index = 2
        }
    }
}

private struct CoinSection: View {
    let list: TrendingResponse
    @Binding var likedCoinIDs: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Top15 Coin")
                .bold()
                .font(.title)
            if #available(iOS 17, *) {
                ScrollView(.horizontal) {
                    CoinGridView(list: list, category: .coin, likedCoinIDs: $likedCoinIDs)
                        .scrollTargetLayout()
                }
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.viewAligned)
            } else {
                ScrollView(.horizontal) {
                    CoinGridView(list: list, category: .coin, likedCoinIDs: $likedCoinIDs)
                }
                .scrollIndicators(.hidden)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

private struct NFTSection: View {
    let list: TrendingResponse
    @Binding var likedCoinIDs: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Top7 NFT")
                .bold()
                .font(.title)
            if #available(iOS 17, *) {
                ScrollView(.horizontal) {
                    CoinGridView(list: list, category: .nft, likedCoinIDs: $likedCoinIDs)
                        .scrollTargetLayout()
                }
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.viewAligned)
            } else {
                ScrollView(.horizontal) {
                    CoinGridView(list: list, category: .nft, likedCoinIDs: $likedCoinIDs)
                }
                .scrollIndicators(.hidden)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

private struct CoinGridView: View {
    enum Category {
        case coin
        case nft
    }
    
    let list: TrendingResponse
    let category: Category
    
    @Binding var likedCoinIDs: [String]
    
    var row: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    var body: some View {
        LazyHGrid(rows: row, spacing: 20, content: {
            switch category {
            case .coin:
                ForEach(Array(list.coins.enumerated()), id: \.element) { index, item in
                    NavigationLink {
                        ChartView(likedCoinIDs: $likedCoinIDs, id: item.item.id)
                    } label: {
                        rowView(item.item, index + 1)
                    }
                }
            case .nft:
                ForEach(Array(list.nfts.enumerated()), id: \.element) { index, item in
                    rowView(item, index + 1)
                }
            }
        })
    }
    
    func rowView(_ item: TrendingCoinItem, _ index: Int) -> some View {
        HStack {
            Text("\(index)")
                .bold()
                .font(.title2)
                .foregroundStyle(.black)
            
            AsyncImage(url: URL(string: item.small)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                case .failure(_):
                    Color.gray
                @unknown default:
                    Color.gray
                }
            }
            .frame(width: 40, height: 40)
            
            VStack(alignment: .leading) {
                Text(item.name)
                    .bold()
                    .foregroundStyle(.black)
                Text(item.capitalSymbol)
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(item.data.price.formatted(.currency(code: "usd")))
                    .bold()
                    .foregroundStyle(.black)
                Text(item.data.priceChangePercentage24h.priceChange)
                    .font(.caption)
                    .bold()
                    .foregroundStyle(item.data.priceChangePercentage24h.krw.isLess(than: 0) ? .blue : .red)
            }
        }
        .padding(.vertical, 10)
        .frame(width: 300)
    }
    
    func rowView(_ item: TrendingNFTItem, _ index: Int) -> some View {
        HStack {
            Text("\(index)")
                .bold()
                .font(.title2)
                .foregroundStyle(.black)
            
            AsyncImage(url: URL(string: item.thumb)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                case .failure(_):
                    Color.gray
                @unknown default:
                    Color.gray
                }
            }
            .frame(width: 40, height: 40)
            
            VStack(alignment: .leading) {
                Text(item.name)
                    .bold()
                    .foregroundStyle(.black)
                Text(item.capitalSymbol)
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(item.data.floorPrice)
                    .bold()
                    .foregroundStyle(.black)
                Text(item.data.priceChange)
                    .font(.caption)
                    .bold()
                    .foregroundStyle(Double(item.data.floorPriceInUsd24hPercentageChange)!.isLess(than: 0) ? .blue : .red)
            }
        }
        .padding(.vertical, 10)
        .frame(width: 300)
    }
}
//
//#Preview {
//    TrendingView()
//}
