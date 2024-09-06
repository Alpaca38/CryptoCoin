//
//  SearchView.swift
//  CryptoCoin
//
//  Created by 조규연 on 9/6/24.
//

import SwiftUI

struct SearchView: View {
    @State private var searchQuery = ""
    @State private var list: Coins = []
    @Binding var likedCoinIDs: [String]
    
    var body: some View {
        NavigationView {
            coinListView()
                .searchable(text: $searchQuery, prompt: "코인을 검색해보세요.")
                .onSubmit(of: .search) {
                    CoingeckoAPI.shared.searchCoin(query: searchQuery) { data in
                        list = data.coins
                    }
                }
                .navigationTitle("Search")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Image(systemName: "person")
                            .asButton {
                                print("프로필 버튼")
                            }
                    }
                }
        }
    }
    
    func coinListView() -> some View {
        ScrollView {
            LazyVStack {
                ForEach($list, id: \.id) { $item in
                    RowView(item: $item, likedCoinIDs: $likedCoinIDs)
                }
            }
        }
    }
}

private struct RowView: View {
    @Binding var item: Coin
    @Binding var likedCoinIDs: [String]
    
    var body: some View {
        HStack {
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
                Text(item.symbol)
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            Spacer()
            Image(systemName: likedCoinIDs.contains(item.id) ? "star.fill" : "star")
                .asButton {
                    toggleLike()
                }
                .foregroundStyle(.purple)
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 20)
    }
    
    func toggleLike() {
        if likedCoinIDs.contains(item.id) {
            likedCoinIDs.removeAll { $0 == item.id }
        } else {
            likedCoinIDs.append(item.id)
        }
    }
}

//#Preview {
//    SearchView()
//}
