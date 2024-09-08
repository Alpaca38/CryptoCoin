//
//  FavoriteView.swift
//  CryptoCoin
//
//  Created by 조규연 on 9/6/24.
//

import SwiftUI

struct FavoriteView: View {
    @Binding var likedCoinIDs: [String]
    @State private var list: MarketResponse = []
    
    var body: some View {
        NavigationView {
            ScrollView {
                FavoriteCoinGridView(list: $list, likedCoinIDs: $likedCoinIDs)
                    .padding()
            }
            .navigationTitle("Favorite Coin")
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
                if likedCoinIDs.isEmpty {
                    list.removeAll()
                } else {
                    let result = try await CoingeckoAPI.shared.getMarketData(ids: likedCoinIDs)
                    list = result
                }
            } catch {
                print(error)
            }
        }
        .refreshable {
            do {
                if likedCoinIDs.isEmpty {
                    list.removeAll()
                } else {
                    let result = try await CoingeckoAPI.shared.getMarketData(ids: likedCoinIDs)
                    list = result
                }
            } catch {
                print(error)
            }
        }
    }
}

private struct FavoriteCoinGridView: View {
    @Binding var list: MarketResponse
    @Binding var likedCoinIDs: [String]
    
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    var body: some View {
        LazyVGrid(columns: columns, content: {
            ForEach(list, id: \.id) { item in
                NavigationLink {
                    NavigationLazyView(ChartView(likedCoinIDs: $likedCoinIDs, id: item.id))
                } label: {
                    coinItem(item)
                }
                .draggable(item)
                .dropDestination(for: MarketItem.self) { items, location in
                    guard let droppedItem = items.first else { return false }
                    
                    if let sourceIndex = list.firstIndex(where: { $0.id == droppedItem.id }),
                       let destinationIndex = list.firstIndex(where: { $0.id == item.id }) {
                        withAnimation {
                            let draggedItem = list.remove(at: sourceIndex)
                            list.insert(draggedItem, at: destinationIndex)
                        }
                    }
                    return true
                }
            }
        })
    }
    
    func coinItem(_ item: MarketItem) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25.0)
                .fill(.white)
                .aspectRatio(1, contentMode: .fit)
                .shadow(radius: 5)
            VStack {
                CoinSymbolView(item: item)
                Spacer()
                VStack(alignment: .trailing) {
                    Text(item.currentPrice.formatted(.currency(code: "krw")))
                        .bold()
                        .foregroundStyle(.black)
                    Text(item.priceChange)
                        .font(.caption)
                        .bold()
                        .foregroundStyle(item.priceChangePercentage24h.isLess(than: 0) ? .blue : .red)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 10)
                        .background(item.priceChangePercentage24h.isLess(than: 0) ? .blue.opacity(0.5) : .red.opacity(0.5))
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding()
        }
    }
}

struct CoinSymbolView: View {
    let item: MarketItem
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: item.image)) { phase in
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
            .frame(width: 45, height: 45)
            
            VStack(alignment: .leading) {
                Text(item.name)
                    .bold()
                    .foregroundStyle(.black)
                Text(item.capitalSymbol)
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            Spacer()
        }
    }
}
//
//#Preview {
//    FavoriteView()
//}
