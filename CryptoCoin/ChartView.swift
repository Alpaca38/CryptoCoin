//
//  ChartView.swift
//  CryptoCoin
//
//  Created by 조규연 on 9/7/24.
//

import SwiftUI
import Charts

struct ChartView: View {
    @State private var data: MarketItem = MarketItem(id: "a", name: "Solana", symbol: "", image: "", currentPrice: 23432342, priceChangePercentage24h: 3.22, low24h: 43234, high24h: 24422342, ath: 34423422, athDate: "", atl: 2333, atlDate: "", lastUpdated: "2024-04-07T16:49:31.736Z", sparklineIn7d: SparkLine(price: [
        59146.24979875298,
        59271.74724991423,
        59213.551753395084,
        59128.64459534604,
        59253.327959791764,
        59332.93325713423,
        59193.30300146088,
        59150.83975964007,
        59168.47919932165,
        59005.487686977234,
        58975.01623858652,
        59019.35217652168,
        59131.873659225435,
        59151.42498480989,
        59197.45730249457,
        59084.71856653795,
        59082.916196810635,
        58981.11791553521,
        58893.87165410129,
        59051.49057272925,
        58891.92517026088,
        58853.53926445986,
        58925.461969271746,
        59027.35485109313,
        58972.13921541655,
        59021.65251754194,
        58922.336373481114,
        58644.573706545554,
        58534.480695240316,
        58503.32213878224,
        58331.72698808311,
        58131.30807597719,
        58193.83008303418,
        58318.17819955592,
        58271.00932331365,
        58200.559267471,
        57995.47189871917,
        58253.180839153545,
        57995.987458535354,
        57744.186227203034,
        57883.88880512065,
        58139.9258201694,
        57943.3495960086,
        58147.22230395923,
        58533.92089209154,
        58607.98923019267,
        58168.06231803104,
        57637.83573404503,
        57383.549100481745,
        57423.47573048797,
        57478.32132172089,
        57639.47999990747,
        57660.6053771104,
        57715.35936374439,
        57627.09794275039,
        57778.35227320422,
        57701.59785865507,
        57557.045542139196,
        57989.956749165074,
        58444.2439600214,
        58410.307545954296,
        58361.898572657774,
        58389.63264298334,
        58189.0157041461,
        58611.971365503894,
        58574.54981135888,
        58352.56971842717,
        58468.85708149525,
        58493.30439764116,
        58564.85288879264,
        59245.901046591396,
        59081.894737399656,
        59231.01284443869,
        59116.72450306674,
        59387.948038510054,
        59522.41951320161,
        59320.34837813365,
        59101.41640164991,
        59029.26825418049,
        59014.71587794109,
        58958.44061193983,
        59093.98582741865,
        58856.27591419819,
        59032.872760216815,
        59037.52112338955,
        59220.85676099221,
        59228.65531821293,
        58102.7723974071,
        57820.0858422582,
        57817.938308376615,
        57748.66507488688,
        57784.356878454455,
        58167.34072631633,
        58181.32218165241,
        58208.6399239705,
        58045.417628622956,
        57786.55294435445,
        57813.69706883217,
        56160.11214505884,
        56618.69625548734,
        56780.01228562741,
        56619.156108408315,
        56670.89762145378,
        56403.90393632768,
        56578.869167875564,
        56689.10810974751,
        56734.14155966517,
        56472.8487542655,
        56522.61204502666,
        56627.70902517211,
        56551.269804683594,
        56471.709617939356,
        57576.97600585592,
        58120.08717111554,
        58393.35074858366,
        57822.842857142816,
        57761.163784722565,
        57983.83427211197,
        57995.679460486725,
        58183.50471420094,
        58140.1028915011,
        58087.76243010292,
        58011.60188693599,
        57749.22706431235,
        57676.00401788212,
        57249.670261443425,
        57155.08709783639,
        57063.580676781254,
        57164.44799899651,
        57163.90747340435,
        56990.33886814557,
        56709.122352946004,
        56762.03833637063,
        56671.36783827192,
        56758.79147824886,
        57125.4501514749,
        56404.29960422861,
        56047.62020016585,
        56443.49795536377,
        56522.572068468406,
        56414.454392688735,
        56040.03890248612,
        56200.64911676952,
        56037.78751865841,
        56116.08146432956,
        56276.037013870904,
        56004.497575819725,
        56538.22821522616,
        56746.166395129345,
        56707.739984513784,
        56511.21182542301,
        56447.17153444231,
        56366.669702838466,
        55812.44318192622,
        55782.373950107845,
        55937.23817176504,
        56048.55200528273,
        55883.98715130142,
        56805.55106357134,
        55324.91474531126,
        54481.51033537016,
        54008.69564063515,
        54302.84348921811,
        53760.5950543657,
        53752.943586110996,
        53491.82745304818,
        53304.61527374619,
        53803.47840034575,
        53700.61737164216
      ]))
    
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
                    .foregroundStyle(.red)
                Text("Today")
            }
        }
    }
    
    func coinChart() -> some View {
        Chart {
            ForEach(Array(data.sparklineIn7d!.price.enumerated()), id: \.offset) { index, value in
                AreaMark(
                    x: .value("Index", index),
                    yStart: .value("value", 50000),
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
        .chartYScale(domain: 50000...60000)
    }
    
    func lastUpdateView() -> some View {
        Text("2/21 11:53:50 업데이트")
            .frame(maxWidth: .infinity, alignment: .trailing)
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
                .foregroundStyle(.black)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ChartView()
}
