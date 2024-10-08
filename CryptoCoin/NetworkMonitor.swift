//
//  NetworkMonitor.swift
//  CryptoCoin
//
//  Created by 조규연 on 9/8/24.
//

import Combine
import Network

final class NetworkMonitor: ObservableObject {
    @Published var isConnected: Bool = true
    private let pathMonitor = NWPathMonitor()
    private let monitorQueue = DispatchQueue(label: "NetworkMonitorQueue")

    init() {
        pathMonitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isConnected = (path.status == .satisfied)
            }
        }
        pathMonitor.start(queue: monitorQueue)
    }
}
