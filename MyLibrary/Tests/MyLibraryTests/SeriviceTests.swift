import XCTest
@testable import MyLibrary

final class IntegrationTests: XCTestCase {
    func testService() async throws{
        // Given
        let WeatherService = WeatherServiceImpl()
        
        //When
        let temp = try await WeatherService.getTemperature()
        
        // Then
        XCTAssertEqual(temp,286)
    }

}

