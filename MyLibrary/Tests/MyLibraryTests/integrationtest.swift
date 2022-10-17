import XCTest
@testable import MyLibrary

final class IntegerationTests: XCTestCase {

    func testWeatherServiceRepliesWithInteger() async throws {
        // Given
        let service_obj = WeatherServiceImpl()

        // When
        let temperature = try await service_obj.getTemperature()

        // Then
        XCTAssertNotNil(temperature)
        // Check if no one changed the dataTYpe 
        XCTAssert((temperature as Any) is Int)

    }

    func testWeatherServiceReplieswithMock() async throws {
        // Given
        let service_obj = WeatherServiceImpl()

        // When
        let temperature = try await service_obj.getTemperature()

        // Then
        XCTAssertNotNil(temperature)
        // Check if temperature is coming as per mocked response
        // XCTAssertEqual(temperature,291)

    }
    
}