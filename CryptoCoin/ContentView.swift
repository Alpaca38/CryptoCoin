//
//  ContentView.swift
//  CryptoCoin
//
//  Created by 조규연 on 9/6/24.
//

import SwiftUI

struct ContentView: View {
    @State private var index = 0
    @State private var likedCoinIDs: [String] = []
    @StateObject private var networkMonitor = NetworkMonitor()
    
    var body: some View {
        if !networkMonitor.isConnected {
            Text("네트워크 연결이 해제되었습니다. 네트워크 상태를 확인해주세요.")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .font(.system(size: 14, weight: .bold))
                .transition(.move(edge: .top))
        }
        
        TabView(selection: $index) {
            TrendingView(index: $index, likedCoinIDs: $likedCoinIDs)
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                }
                .tag(0)
            
            SearchView(likedCoinIDs: $likedCoinIDs)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }
                .tag(1)
            
            FavoriteView(likedCoinIDs: $likedCoinIDs)
                .tabItem {
                    Image(systemName: "folder")
                }
                .tag(2)
        }
        .tint(.purple)
    }
}


//#Preview {
//    ContentView()
//}
