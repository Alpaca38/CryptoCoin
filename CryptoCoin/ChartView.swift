//
//  ChartView.swift
//  CryptoCoin
//
//  Created by 조규연 on 9/7/24.
//

import SwiftUI
import Charts

struct ChartView: View {
    @Binding var likedCoinIDs: [String]
    let id: String
    
    @State private var data: MarketItem = MarketItem(id: "", name: "", symbol: "", image: "", currentPrice: 0, priceChangePercentage24h: 0, low24h: 0, high24h: 0, ath: 0, athDate: "", atl: 0, atlDate: "", lastUpdated: "", sparklineIn7d: SparkLine(price: []))
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            nameView()
            currentPrice()
            PriceGrid(data: data)
            coinChart()
            lastUpdateView()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .toolbar {
            Image(systemName: likedCoinIDs.contains(data.id) ? "star.fill" : "star")
                .asButton {
                    toggleLike()
                }
        }
        .task {
            do {
                let result = try await CoingeckoAPI.shared.getMarketData(ids: [id], sparkline: "true")
                data = result.first!
            } catch {
                print(error)
            }
        }
    }
    
    func nameView() -> some View {
        HStack {
            AsyncImage(url: URL(string: data.image)) { phase in
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
            Text(data.name)
                .font(.largeTitle)
                .bold()
        }
    }
    
    func currentPrice() -> some View {
        VStack(alignment: .leading) {
            Text(data.currentPrice.formatted(.currency(code: "krw")))
                .font(.largeTitle)
                .bold()
            
            HStack {
                Text(data.priceChange)
                    .foregroundStyle(data.priceChangePercentage24h.isLess(than: 0) ? .blue : .red)
                Text("Today")
            }
        }
    }
    
    func coinChart() -> some View {
        Chart {
            ForEach(Array(data.sparklineIn7d!.price.enumerated()), id: \.offset) { index, value in
                AreaMark(
                    x: .value("Index", index),
                    yStart: .value("value", data.sparklineIn7d!.lowPrice),
                    yEnd: .value("value", value)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            Color.purple.opacity(0.7),
                            Color.purple.opacity(0.1)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                
                LineMark(
                    x: .value("Index", index),
                    y: .value("Value", value)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(.purple)
            }
        }
        .frame(height: 300)
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .chartYScale(domain: data.sparklineIn7d!.lowPrice...data.sparklineIn7d!.highPrice)
    }
    
    func lastUpdateView() -> some View {
        Text(data.lastUpdatedText)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .font(.caption)
            .foregroundStyle(.gray)
    }
    
    func toggleLike() {
        if likedCoinIDs.contains(data.id) {
            likedCoinIDs.removeAll { $0 == data.id }
        } else {
            likedCoinIDs.append(data.id)
        }
    }
}

private struct PriceGrid: View {
    let data: MarketItem
    
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 20, content: {
            priceStack("고가", data.high24h)
                .foregroundStyle(.red)
            priceStack("저가", data.low24h)
                .foregroundStyle(.blue)
            priceStack("신고점", data.ath)
                .foregroundStyle(.red)
            priceStack("신저점", data.atl)
                .foregroundStyle(.blue)
        })
    }
    
    func priceStack(_ title: String, _ price: Double) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .bold()
            Text(price.formatted(.currency(code: "krw")))
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

//#Preview {
//    ChartView()
//}
