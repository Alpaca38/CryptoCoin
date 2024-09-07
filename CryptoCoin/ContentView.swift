//
//  ContentView.swift
//  CryptoCoin
//
//  Created by 조규연 on 9/6/24.
//

import SwiftUI

struct ContentView: View {
    @State private var likedCoinIDs: [String] = []
    
    var body: some View {
        TabView {
            TrendingView(likedCoinIDs: $likedCoinIDs)
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                }
            
            SearchView(likedCoinIDs: $likedCoinIDs)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }
            
            FavoriteView(likedCoinIDs: $likedCoinIDs)
                .tabItem {
                    Image(systemName: "folder")
                }
        }
        .tint(.purple)
    }
}


//#Preview {
//    ContentView()
//}
