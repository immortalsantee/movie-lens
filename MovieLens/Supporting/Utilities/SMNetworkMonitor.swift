//
//  SMNetworkMonitor.swift
//  MovieLens
//
//  Created by Santosh Maharjan on 1/16/26.
//

import Foundation
import Network
import Combine

final class SMNetworkMonitor {
    static let shared = SMNetworkMonitor()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "com.movielens.smnetworkmonitor")

    @Published private(set) var isConnected: Bool = true

    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = (path.status == .satisfied)
            }
        }
        monitor.start(queue: queue)
        DispatchQueue.main.async {
            self.isConnected = (self.monitor.currentPath.status == .satisfied)
        }
    }

    deinit {
        monitor.cancel()
    }
}
