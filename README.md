# PasseiNetworking

[![CI Status](https://img.shields.io/travis/95707007/PasseiNetworking.svg?style=flat)](https://travis-ci.org/95707007/PasseiNetworking)
[![Version](https://img.shields.io/cocoapods/v/PasseiNetworking.svg?style=flat)](https://cocoapods.org/pods/PasseiNetworking)
[![License](https://img.shields.io/cocoapods/l/PasseiNetworking.svg?style=flat)](https://cocoapods.org/pods/PasseiNetworking)
[![Platform](https://img.shields.io/cocoapods/p/PasseiNetworking.svg?style=flat)](https://cocoapods.org/pods/PasseiNetworking)

## 🔎 Sobre

`PasseiNetworking` é uma poderosa e flexível biblioteca em Swift para realizar requisições de API de forma assíncrona, com suporte a interceptação de requisições.

### 🛠️ Dependências

- **PasseiLogManager**: Requerido para logs detalhados.
- **PasseiJWT**: (Sem documentação ainda) - Verificação de JWT.

## 🔧 Instalação

Para integrar `PasseiNetworking` ao seu projeto, adicione a seguinte linha ao seu arquivo `Podfile`:

```ruby
pod 'PasseiNetworking'
```

### Em seguida, execute o comando:

```swift
pod install
```
## ⚙️ Uso Básico

Comece importando o módulo em seu código:

```swift
import PasseiNetworking
```
### 1. Criação de uma Instância da NSAPIService
Crie uma instância da NSAPIService:

```swift
let apiService = NSAPIService()
```
### 2. Configuração de URL Base e Porta
Antes de começar, defina a URL base e a porta na sua AppDelegate:

```swift
NSAPIConfiguration.shared.setBaseUrl("http://localhost")
NSAPIConfiguration.shared.setPort(3000)
```

### 3. Configuração de Interceptor
A NSAPIService permite a configuração de interceptadores para modificar ou adicionar informações às requisições. Por exemplo:

```swift
let interceptor = NSRequestInterceptor()
interceptor.addHeader("Authorization", value: "Bearer token")
apiService.interceptor(interceptor)
```

### 4. Realização de Requisições
Depois de configurar a NSAPIService, você pode fazer requisições de forma assíncrona usando a função fetchAsync ou com uma closure usando fetch.

Requisição Assíncrona:
```swift
let nsParameters = NSParameters(method: .GET, path: .examplePath)
do {
    let response = try await apiService.fetchAsync(MyModel.self, nsParameters: nsParameters)
    // Utilize a resposta conforme necessário
} catch {
    // Lidar com possíveis erros
}
```

Requisição com Closure

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

### 5. Configuração Avançada
Interceptação de Requisições
A NSAPIService suporta interceptadores para adicionar ou modificar informações das requisições. Exemplo:

```swift
let interceptor = NSRequestInterceptor()
interceptor.addHeader("Authorization", value: "Bearer token")
apiService.interceptor(interceptor)
```
Customização da URL
Personalize a URL base para requisições utilizando NSCustomBaseURLInterceptor:

```swift
let baseURLInterceptor = NSCustomBaseURLInterceptor(baseURL: "https://api.example.com")
apiService.customURL(baseURLInterceptor)
```

## 🧰 Configuração Avançada

### 1. Tratamento de Erros
A NSAPIService retorna um Result com sucesso ou falha. Certifique-se de lidar com possíveis erros em suas chamadas de requisição.

```swift
case .failure(let error):
    if let nsError = error as? NSAPIError {
        switch nsError {
        case .unknowError(let string):
            break
        case .info(let string):
            break
        case .acknowledgedByAPI(let nSAcknowledgedByAPI):
            break
        case .noInternetConnection:
            break
        }
        return
    }

NSAPIError.outherError(withError: error) { e in }
```

### 2. Paths
Configure seus paths de maneira organizada:

```swift
import Foundation
import PasseiNetworking

/// Todos os paths dos aplicativos, caso exista mais de um
public enum OABAPIPath {
    case caseA(MyAppPathA)
    case caseB(MyAppPathB)
}

/// Paths da aplicação
public enum MyAppPathA: String {
    case auth = "auth"
    case resiter = "register"
}

public enum MyAppPathB: String {
    case outher = "outher"
}

extension OABAPIPath: NSRawValue {
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

### 3. Chamando um Request
Exemplo mais completo utilizando uma factory:

```swift
class Service {
    
    let factory: NSHTTPServiceFactoryProtocol
    
    init(withFactory factory: NSHTTPServiceFactoryProtocol) {
        self.factory = factory
    }
    
    func getCurrent() async throws -> MyResponse? {
        
        let response = try await factory.service
          .interceptor(DefaultInterceptor())
            .fetchAsync(
                MyRequest.self,
                nsParameters: NSParameters(
                    method: .GET,
                    path: MYPATH.name(.user)
                )
            )
        return response
        
    }
    
    func update(request: MyRequest) async throws  {
        
        let _ = try await factory.service
          .interceptor(DefaultInterceptor())
          .authorization(DefaltAuthorization())
            .fetchAsync(
                NSEmptyModel.self, // Resposta sem dados. Assim -> {}
                nsParameters: NSParameters(
                    method: .POST,
                    httpRequest: request,
                    path: MYPATH.name(.outherPath)
                )
            )
    }
}
```

### 4. Adicionando Delegate
Adicione um delegate para mudar algumas configurações:

```swift
extension OABPasswordRecoveryService: NSAPIServiceDelegate {
    
    // Adicione delegate factory.service.delegate = self
    
    var configurationSession: URLSessionConfiguration { .timeConsumingBackgroundTasks }
    
    func networkUnavailableAction(withURL url: URL?) {
         
    }
}
```

Este pacote está funcionando, mas ainda está sendo implementado melhorias.

## 📝 Autores
ziminny@gmail.com
gabrielmors210@gmail.com

## 🔒 Licença
MIT


--------------------------------------------------------------------------------------------

