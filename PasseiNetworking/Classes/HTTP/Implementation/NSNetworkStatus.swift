//
//  NSNetworkStatus.swift
//
//
//  Created by Vagner Oliveira on 02/06/23.
//

import Network

/// Classe para monitorar o status da conexão de rede.
public class NSNetworkStatus: ObservableObject {

    /// Publicado quando o status de conexão é alterado.
    @Published public var isConnected = true
    
    /// Inicializador da classe NSNetworkStatus.
    /// - Parameters:
    ///   - queue: Fila para execução das atualizações de status.
    public init(queue: DispatchQueue = .main) {
        let monitor = NWPathMonitor()
           
        let semaphore = DispatchSemaphore(value: 0)

        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    self.isConnected = true
                }
            } else {
                DispatchQueue.main.async {
                    self.isConnected = false
                }
            }

            semaphore.signal()
        }

        monitor.start(queue: queue)

        semaphore.wait()
    }
}

