





import XCTest
import MyLibrary
@testable import MyLibrary


final class MyIntegrationTest: XCTestCase {
    
    func testingWeatherModel() async throws {
        
        let weatherService = WeatherServiceImpl()
        
        
        let temperature = try await weatherService.getTemperature()
        
        XCTAssertEqual(temperature, 62)
    }
}

