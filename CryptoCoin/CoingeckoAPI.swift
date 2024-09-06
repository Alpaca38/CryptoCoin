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
}
