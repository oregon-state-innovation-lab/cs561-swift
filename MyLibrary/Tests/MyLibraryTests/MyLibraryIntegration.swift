import XCTest
@testable import MyLibrary

final class IntegerationTests: XCTestCase {

    func testWeatherServiceRepliesWithInteger() async throws {

        let service_obj = WeatherServiceImpl()
        let temperature = try await service_obj.getTemperature()
        XCTAssertNotNil(temperature)
        XCTAssert((temperature as Any) is Int)

    }

    func testWeatherServiceReplieswithMock() async throws {

        let service_obj = WeatherServiceImpl()
        let temperature = try await service_obj.getTemperature()
        XCTAssertNotNil(temperature)
    }

}