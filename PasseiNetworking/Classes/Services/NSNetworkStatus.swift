//
//  NSNetworkStatus.swift
//
//
//  Created by Vagner Oliveira on 02/06/23.
//

import Network

public class NSNetworkStatus:ObservableObject {

    @Published public var isConnected = true
    
    public init(queue:DispatchQueue = .main) {
        let monitor = NWPathMonitor()
        
        let localQueue:((_ callback: @escaping () -> Void) -> Void) = { callback in
            if queue == Thread.main {
                DispatchQueue.main.async {
                    callback()
                }
            } else {
                DispatchQueue.global().sync {
                   callback()
                }
            }
        }
   
        let semaphore = DispatchSemaphore(value: 0)

        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                localQueue { self.isConnected = true }
            } else {
                localQueue { self.isConnected = false }
            }

            semaphore.signal()
        }

        let queue = DispatchQueue.global()
        monitor.start(queue: queue)

        semaphore.wait()

        
    }
}
