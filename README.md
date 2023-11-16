# PasseiNetworking

[![CI Status](https://img.shields.io/travis/95707007/PasseiNetworking.svg?style=flat)](https://travis-ci.org/95707007/PasseiNetworking)
[![Version](https://img.shields.io/cocoapods/v/PasseiNetworking.svg?style=flat)](https://cocoapods.org/pods/PasseiNetworking)
[![License](https://img.shields.io/cocoapods/l/PasseiNetworking.svg?style=flat)](https://cocoapods.org/pods/PasseiNetworking)
[![Platform](https://img.shields.io/cocoapods/p/PasseiNetworking.svg?style=flat)](https://cocoapods.org/pods/PasseiNetworking)

A `NSAPIService` é uma classe que oferece funcionalidades para realizar requisições de API de forma assíncrona e com suporte a interceptação de requisições.

### Esse pacote depende do pacote PasseiLogManager, caso queira usar verificação de JTW usar o pacote PasseiJWT (Sem documentação ainda)

## Uso Básico

Para usar a `NSAPIService` em seu projeto, siga os passos abaixo:

### Importar o Módulo

```swift
import PasseiLogManager
import NSAPIService
```

## Criação de uma Instância da NSAPIService
Crie uma instância da NSAPIService em seu código:
```swift
let apiService = NSAPIService()
```

## URL Base e Porta
Antes de tudo, pode ser na AppDelegate, adicione:
```swift
NSAPIConfiguration.shared.setBaseUrl("http://localhost")
NSAPIConfiguration.shared.setPort(3000)
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
```swift
case .failure(let error):
    if let nsError = error as? NSAPIError {
        switch nsError {
        case .unknowError(let string):
            break;
        case .info(let string):
            break;
        case .acknowledgedByAPI(let nSAcknowledgedByAPI):
            break;
        case .noInternetConnection:
            break;
        }
        return
    }

NSAPIError.outherError(withError: error) { e in }
```

## Paths
Aqui esta um exemplo de como configurar seus paths:
```swift
import Foundation
import PasseiNetworking


/// Todos os paths dos aplicativos, caso exista mais de um
public enum OABAPIPath {
    case caseA(MyAppPathA)
    case caseB(MyAppPathB)
}


/// Paths da aplicatico
public enum MyAppPathA:String {
    case auth = "auth"
    case resiter = "register"
}

public enum MyAppPathB:String {
    case outher = "outher"
}

extension OABAPIPath:NSRawValue {
    public var rawValue: String {
        switch self {
        case .caseA(let subcase):
            return subcase.rawValue
            
        case .caseB(let subcase):
            return subcase.rawValue
            
        }
    }
}

```

# Chame um request para cada requisição, caso prefira fazer mais de uma requisição na mesma instância da sua service class utilizar a factory:
Aqui esta um exemplo mais completo

```swift
class Service {
    
    let factory:NSHTTPServiceFactoryProtocol
    
    required init(withFactory factory:NSHTTPServiceFactoryProtocol) {
        self.factory = factory
    }
    
    func getCurrent() async throws -> MyResponse? {
        
        let response = try await factory.service
          .interceptor(DefaultInterceptor())
            .fetchAsync(
                MyRequest.self,
                nsParameters:NSParameters(
                    method: .GET,
                    path: MYPATH.name(.user)
                )
            )
        
        return response
        
    }
    
    func update(request:MyRequest) async throws  {
        
        let _ = try await factory.service
          .interceptor(DefaultInterceptor())
          .authorization(DefaltAuthorization())
            .fetchAsync(
                NSEmptyModel.self, //Resposta sem dados. Assim -> {}
                nsParameters:NSParameters(
                    method: .POST,
                    httpRequest: request,
                    path: MYPATH.name(.outherPath)
                )
            )
    }

}
```

Esse pacote funciona mas ainda esta sendo implementado melhorias

## Author
ziminny@gmail.com

## Licença
MIT
