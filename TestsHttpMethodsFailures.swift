import XCTest
@testable import PasseiNetworking

class TestsHttpMethodsFailures: XCTestCase {
    
    var httpInterceptor: HTTPInterceptorBuilder?
    
    @NSFactory(factory: MockHTTPServiceFactory())
    var service: HttpMethodsFailuresService
    
    override func setUpWithError() throws {
        httpInterceptor = HTTPInterceptorBuilder()
        httpInterceptor?
            .setHTTPConfiguration()
            .setInterceptorParams()
        
    }
    
    override func tearDownWithError() throws {
        MockURLProtocol.requestHandler = nil
    }
    
    func testFailureWithoutAuthGET_400() async {
        httpInterceptor?.statusCode = NSHTTPStatusCodes.badRequest
        
        do {
            
            let _ = try await service.testFailureWithoutAuthGET_400()
            fatalError("Nao pode chegar aqui")
            
        } catch {
            
            if let error = error as? NSAPIError, case let .acknowledgedByAPI(response) = error {
                
                XCTAssertEqual(response.message, "Swif test case")
                XCTAssertEqual(response.statusCode, NSHTTPStatusCodes.badRequest)
                
            } else {
                XCTFail()
            }
        }
        
    }
    
    func testFailureWithoutAuthGET_401() async {
        
        httpInterceptor?.statusCode = NSHTTPStatusCodes.unauthorized
        
        do {
            
            let _ = try await service.testFailureWithoutAuthGET_401()
            fatalError("Nao pode chegar aqui")
            
        } catch {
            if let error = error as? NSAPIError, case let .info(message) = error {
                XCTAssertEqual(message, "Provedor de autorização não implementado.")
            } else {
                XCTFail()
            }
        }
        
    }
    
    func testFailureWithoutAuthGET_403() async {
        httpInterceptor?.statusCode = NSHTTPStatusCodes.forbidden
        do {
            
            let _ = try await service.testFailureWithoutAuthGET_403()
            fatalError("Nao pode chegar aqui")
            
        } catch {
            if let error = error as? NSAPIError, case let .acknowledgedByAPI(response) = error {
                XCTAssertEqual(response.message, "Swif test case")
                XCTAssertEqual(response.statusCode, NSHTTPStatusCodes.forbidden)
            } else {
                XCTFail()
            }
        }
        
    }
    
    func testFailureWithoutAuthGET_500() async {
        httpInterceptor?.statusCode = NSHTTPStatusCodes.internalServerError
        do {
            
            let _ = try await service.testFailureWithoutAuthGET_500()
            fatalError("Nao pode chegar aqui")
            
        } catch {
            if let error = error as? NSAPIError, case let .info(message) = error {
                XCTAssertEqual(message, "Erro interno no servidor")
            } else {
                XCTFail()
            }
        }
        
    }
    
}
