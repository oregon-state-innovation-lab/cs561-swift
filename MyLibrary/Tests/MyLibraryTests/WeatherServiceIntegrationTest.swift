import XCTest
import MyLibrary

final class WeatherServiceIntegrationTests: XCTestCase {
    
    public func testweatherSeriveTest_canGetTemperature() async throws {
        // Given
        let temperatureToBeReturned = 12.3
        let weatherSerivce = WeatherServiceImpl()
        
        // When
        let temperature = try await weatherSerivce.getTemperature()
        
        // Then
        XCTAssertNotNil(temperature)
        XCTAssertEqual(temperature, Int(temperatureToBeReturned))
    }
}
