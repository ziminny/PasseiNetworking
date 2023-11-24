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
           
        let semaphore = DispatchSemaphore(value: 0)

        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                queue.async { self.isConnected = true }
            } else {
                queue.async { self.isConnected = false }
            }

            semaphore.signal()
        }

     
        monitor.start(queue: queue)

        semaphore.wait()

        
    }
}
