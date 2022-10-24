import XCTest
@testable import MyLibrary
final class IntegrationTests: XCTestCase {
    func testWeatherService() async throws {
        //Given
        let my_service = WeatherServiceImpl()

        //When
        let temperatureCorvallis = try await my_service.getTemperature()


        //Then
        XCTAssertNotNil(temperatureCorvallis)
        XCTAssert((temperatureCorvallis as Any)is Int)

    }

    func testWeatherServiceMockData()  async throws{
        let my_service = WeatherServiceImpl()
        //When
        let temperatureCorvallis = try await my_service.getTemperature()


        //Then
        XCTAssertNotNil(temperatureCorvallis)
        XCTAssertEqual(temperatureCorvallis,293)
        
    }
          
}
