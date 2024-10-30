import XCTest
@testable import PasseiNetworking

class TestsHttpMethodsSuccess: XCTestCase {
    
    var httpInterceptor: HTTPInterceptorBuilder?
    
    @NSFactory(factory: MockHTTPServiceFactory())
    var service: HttpMethodsSuccessService
    
    override func setUpWithError() throws {
        httpInterceptor = HTTPInterceptorBuilder()
        httpInterceptor?
            .setHTTPConfiguration()
            .setInterceptorParams()
    }
    
    override func tearDownWithError() throws {
        httpInterceptor = nil
        MockURLProtocol.requestHandler = nil
    }
    
    func testSuccessWithoutAuthGET() async throws {
        
        let result = try await service.testSuccessWithoutAuthGET()
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.success, true)
        XCTAssertEqual(httpInterceptor?.httpMethod, .GET)
        XCTAssertEqual(httpInterceptor?.path?.rawValue, Paths.test.rawValue)
        
    }
    
    func testSuccessWithoutAuthPOST() async throws {
        
        let result = try await service.testSuccessWithoutAuthPOST()
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.success, true)
        XCTAssertEqual(httpInterceptor?.httpMethod, .POST)
        XCTAssertEqual(httpInterceptor?.path?.rawValue, Paths.test.rawValue)
        
    }
    
    func testSuccessWithoutAuthPUT() async throws {
        
        let result = try await service.testSuccessWithoutAuthPUT()
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.success, true)
        XCTAssertEqual(httpInterceptor?.httpMethod, .PUT)
        XCTAssertEqual(httpInterceptor?.path?.rawValue, Paths.testQueryString.rawValue)
        
    }
    
    func testSuccessWithoutAuthDELETE() async throws {
        
        let result = try await service.testSuccessWithoutAuthDELETE()
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.success, true)
        XCTAssertEqual(httpInterceptor?.httpMethod, .DELETE)
        XCTAssertEqual(httpInterceptor?.path?.rawValue, Paths.testParam.rawValue)
        
    }
    
}

struct MockData: NSModel {
    let success: Bool
}
