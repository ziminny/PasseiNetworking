//
//  BackgroundTask.swift
//  PasseiCircleAnimation
//
//  Created by Vagner Oliveira on 07/11/23.
//

//https://support.apple.com/en-us/HT210596

import Foundation

public extension URLSessionConfiguration {
    /// Tarefas demoradas em segundo plano
    static var timeConsumingBackgroundTasks:URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = HTTPHeader.headerDict
        configuration.waitsForConnectivity = true
        configuration.timeoutIntervalForRequest = 60 // 1 Minuto
        configuration.timeoutIntervalForResource = 60 * 60 // 1 Hora
        // Não pode usar 3G
        configuration.allowsCellularAccess = false
        // Vai ser requisição pesada em segundo plano
        configuration.allowsExpensiveNetworkAccess = false // (Requisições considerada caras)
        // Vai ser requisição pesada em segundo plano (desabilitar)
        configuration.allowsConstrainedNetworkAccess = false // (Low Data Model)
        return configuration
    }
}

public extension URLSessionConfiguration {
    /// Tarefas medias em segundo plano
    static var averangeBackgroundTasks:URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = HTTPHeader.headerDict
        configuration.waitsForConnectivity = true
        configuration.timeoutIntervalForRequest = 45 // 45 Segundos
        configuration.timeoutIntervalForResource = 60 * 60 / 4 // 15 Minutos
        // Não pode usar 3G
        configuration.allowsCellularAccess = false
        // Vai ser requisição media em segundo plano
        configuration.allowsExpensiveNetworkAccess = false // (Requisições considerada caras)
        // Vai ser requisição media em segundo plano (desabilitar)
        configuration.allowsConstrainedNetworkAccess = false // (Low Data Model)
        return configuration
    }
}

public extension URLSessionConfiguration {
    /// Tarefas leves em segundo plano
    static var lightBackgroundTasks:URLSessionConfiguration {
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = HTTPHeader.headerDict
        configuration.waitsForConnectivity = true
        configuration.timeoutIntervalForRequest = 20 // 20 Segundos
        configuration.timeoutIntervalForResource = 60 * 3 // 3 Minutos
        // Pode usar 3G
        configuration.allowsCellularAccess = true
        // Vai ser requisição leve mas em segundo plano
        configuration.allowsExpensiveNetworkAccess = true // (Requisições considerada caras)
        // Não vai ser requisição pesada
        configuration.allowsConstrainedNetworkAccess = true // (Low Data Model)
        return configuration
    }
}


public extension URLSessionConfiguration {
    /// Tarefa Principal, ex:. Login, Criar conta
    static var noBackgroundTask:URLSessionConfiguration {
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = HTTPHeader.headerDict
        // Não vai esperar, caso de erro ja lança para o usuário
        configuration.waitsForConnectivity = true
        // Pode usar 3G
        configuration.allowsCellularAccess = true
        // Geralmente vai ser requisicoes leves "barata"
        configuration.allowsExpensiveNetworkAccess = true // (Requisições considerada caras pelo sistema)
        // Economia de dados não importa aqui, pois o usuário não esta fazendo requisicoes
        // em background e vai ser tarefa rapida
        configuration.allowsConstrainedNetworkAccess = true // (Low Data Model)
        
        return configuration
    }
}
