
# 🌐 PasseiNetworking

[![CI Status](https://img.shields.io/travis/95707007/PasseiNetworking.svg?style=flat)](https://travis-ci.org/95707007/PasseiNetworking)
[![Version](https://img.shields.io/cocoapods/v/PasseiNetworking.svg?style=flat)](https://cocoapods.org/pods/PasseiNetworking)
[![License](https://img.shields.io/cocoapods/l/PasseiNetworking.svg?style=flat)](https://cocoapods.org/pods/PasseiNetworking)
[![Platform](https://img.shields.io/cocoapods/p/PasseiNetworking.svg?style=flat)](https://cocoapods.org/pods/PasseiNetworking)

O **PasseiNetworking** é uma poderosa e flexível biblioteca em Swift para realizar requisições HTTP assíncronas, com suporte a configuração de headers, paths dinâmicos, interceptores e autenticação.

---

## **Descrição**

A biblioteca oferece uma interface prática para:

- Configuração de URL base e paths personalizados.
- Requisições assíncronas com `async/await`.
- Interceptação e modificação de requisições (ex.: headers de autenticação).
- Tratamento de erros centralizado.

---

## **Requisitos**

- **Swift**: 5.0 ou superior
- **iOS**: Compatível com iOS 11.0+
- **PasseiLogManager**: Dependência para logs.
- **PasseiJWT**: (opcional) para autenticação JWT.

---

## **Instalação**

### **Usando CocoaPods**

Adicione a seguinte linha ao seu arquivo `Podfile`:

```ruby
pod 'PasseiNetworking'
```

Em seguida, execute o comando:

```bash
pod install
```

---

## **Configuração Inicial**

1. **Defina a URL base e a porta do servidor:**  
   No seu `AppDelegate`, configure o serviço:

   ```swift
   import PasseiNetworking

   NSAPIConfiguration.shared.setBaseUrl("http://localhost")
   NSAPIConfiguration.shared.setPort(3000)
   ```

2. **Configure um interceptor para headers personalizados:**  
   Adicione um interceptor para autenticação ou outros headers.

   ```swift
   let interceptor = NSRequestInterceptor()
   interceptor.addHeader("Authorization", value: "Bearer token")
   apiService.interceptor(interceptor)
   ```

---

## **Uso Básico**

### **1. Fazendo uma Requisição GET**

```swift
let apiService = NSAPIService()

let nsParameters = NSParameters(method: .GET, path: .examplePath)

do {
    let response = try await apiService.fetchAsync(MyModel.self, nsParameters: nsParameters)
    print("Resposta recebida:", response)
} catch {
    print("Erro:", error)
}
```

### **2. Fazendo uma Requisição POST**

```swift
let requestData = MyRequestData(param1: "value")

let nsParameters = NSParameters(
    method: .POST,
    path: .examplePostPath,
    httpRequest: requestData
)

let response = try await apiService.fetchAsync(MyResponseModel.self, nsParameters: nsParameters)
```

### **3. Usando Closure para Requisição**

```swift
apiService.fetch(MyModel.self) { result in
    switch result {
    case .success(let data):
        print("Dados recebidos:", data)
    case .failure(let error):
        print("Erro:", error)
    }
}
```

---

## **Configurações Avançadas**

### **1. Personalização da URL base**

Você pode personalizar a URL base utilizando o interceptor `NSCustomBaseURLInterceptor`.

```swift
let baseURLInterceptor = NSCustomBaseURLInterceptor(baseURL: "https://api.example.com")
apiService.customURL(baseURLInterceptor)
```

### **2. Tratamento de Erros**

A biblioteca retorna um `Result` para indicar sucesso ou falha. Certifique-se de lidar com diferentes tipos de erro.

```swift
switch result {
case .failure(let error):
    if let nsError = error as? NSAPIError {
        switch nsError {
        case .unknowError(let message):
            print("Erro desconhecido:", message)
        case .noInternetConnection:
            print("Sem conexão à internet")
        default:
            print("Erro:", nsError)
        }
    }
}
```

---

## **Contribuição**

Contribuições são bem-vindas! Siga os passos abaixo para colaborar:

1. Faça um fork do projeto.
2. Crie uma branch para suas alterações (`git checkout -b minha-feature`).
3. Faça commit das alterações (`git commit -m 'Minha nova feature'`).
4. Envie as alterações para o seu fork (`git push origin minha-feature`).
5. Abra um Pull Request para revisão.

---

## **Licença**

PasseiNetworking está disponível sob a licença **MIT**. Consulte o arquivo `LICENSE` para mais informações.

---

## **Autores**

- **Vagner Oliveira**  
  E-mail: ziminny@gmail.com
- **Gabriel Mors**  
  E-mail: gabrielmors210@gmail.com

---

## **Recursos úteis**

- [Documentação CocoaPods](https://guides.cocoapods.org/)
- [Swift.org](https://swift.org)
