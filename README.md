# PasseiNetworking

[![CI Status](https://img.shields.io/travis/95707007/PasseiNetworking.svg?style=flat)](https://travis-ci.org/95707007/PasseiNetworking)
[![Version](https://img.shields.io/cocoapods/v/PasseiNetworking.svg?style=flat)](https://cocoapods.org/pods/PasseiNetworking)
[![License](https://img.shields.io/cocoapods/l/PasseiNetworking.svg?style=flat)](https://cocoapods.org/pods/PasseiNetworking)
[![Platform](https://img.shields.io/cocoapods/p/PasseiNetworking.svg?style=flat)](https://cocoapods.org/pods/PasseiNetworking)

A `NSAPIService` é uma classe que oferece funcionalidades para realizar requisições de API de forma assíncrona e com suporte a interceptação de requisições.

## Uso Básico

Para usar a `NSAPIService` em seu projeto, siga os passos abaixo:

### Importar o Módulo

```swift
import PasseiLogManager
import NSAPIService

## Criação de uma Instância da NSAPIService
Crie uma instância da NSAPIService em seu código:
```swift
let apiService = NSAPIService()
```

## Configuração de Interceptor
A NSAPIService permite configurar interceptores para modificar ou adicionar informações às requisições. Por exemplo:
```swift
let interceptor = NSRequestInterceptor()
interceptor.addHeader("Authorization", value: "Bearer token")
apiService.interceptor(interceptor)
```
## Realização de Requisições
Após configurar a NSAPIService, você pode fazer requisições de forma assíncrona usando a função fetchAsync ou com uma closure usando fetch:

- Requisição Assíncrona:
```swift
let nsParameters = NSParameters(method: .GET, path: .examplePath)
do {
    let response = try await apiService.fetchAsync(MyModel.self, nsParameters: nsParameters)
    // Utilize a resposta conforme necessário
} catch {
    // Lidar com possíveis erros
}
```

- Requisição com Closure
```swift 
apiService.fetch(MyModel.self) { result in
    switch result {
    case .success(let myModel):
        // Utilize 'myModel' conforme necessário
        break
    case .failure(let error):
        // Lidar com possíveis erros
        break
    }
}
```

## Configuração Avançada
Interceptação de Requisições
A NSAPIService suporta interceptadores para adicionar ou modificar informações das requisições. Aqui está um exemplo de como adicionar um interceptor:
```swift
let interceptor = NSRequestInterceptor()
interceptor.addHeader("Authorization", value: "Bearer token")
apiService.interceptor(interceptor)
```

## Customização da URL
Você pode personalizar a URL base para requisições utilizando NSCustomBaseURLInterceptor:
```swift
let baseURLInterceptor = NSCustomBaseURLInterceptor(baseURL: "https://api.example.com")
apiService.customURL(baseURLInterceptor)
```

## Tratamento de Erros
A NSAPIService retorna um Result com sucesso ou falha. Certifique-se de lidar com possíveis erros em suas chamadas de requisição.

# Chame um request para cada requisição, caso prefira fazer mais de uma requisição por classe utilizar a factory:

```swift
public protocol NSHTTPServiceFactoryProtocol {
     var service:NSAPIService { get }
}

public class NSHTTPServiceFactory:NSHTTPServiceFactoryProtocol {
    
    public init() {}
    
    public var service:NSAPIService {
        return NSAPIService()
    }
    
}
```

## Author
ziminny@gmail.com

## Licença
MIT
