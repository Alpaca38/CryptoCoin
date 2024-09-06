//
//  CoingeckoAPI.swift
//  CryptoCoin
//
//  Created by 조규연 on 9/6/24.
//

import Foundation

final class CoingeckoAPI {
    private init() { }
    static let shared = CoingeckoAPI()
    
    func searchCoin(query: String, completion: @escaping (SearchResponse) -> Void) {
        guard let url = URL(string: APIKey.baseURL + "search?query=\(query)") else {
            print("Invalid Request")
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                let decodedData = try JSONDecoder().decode(SearchResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(decodedData)
                }
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func getMarketData(ids: [String], sparkline: String = "false") async throws -> MarketResponse {
        var urlComponents = URLComponents(string: APIKey.baseURL + "coins/markets")!
        urlComponents.queryItems = [
            URLQueryItem(name: "vs_currency", value: "krw"),
            URLQueryItem(name: "ids", value: ids.joined(separator: ",")),
            URLQueryItem(name: "sparkline", value: sparkline)
        ]
        
        guard let url = urlComponents.url else {
               throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url) // 응답이 올때까지 기다림
        let decodedData = try JSONDecoder().decode(MarketResponse.self, from: data)
        
        return decodedData
    }
}
