import XCTest
@testable import MyLibrary

final class MyLibraryTests: XCTestCase {
    func testIsLuckyBecauseWeAlreadyHaveLuckyNumber() async {
        // Given
        let mockWeatherService = MockWeatherService(
            shouldSucceed: true,
            shouldReturnTemperatureWithAnEight: false
        )

        let myLibrary = MyLibrary(weatherService: mockWeatherService)

        // When
        let isLuckyNumber = await myLibrary.isLucky(8)

        // Then
        XCTAssertNotNil(isLuckyNumber)
        XCTAssert(isLuckyNumber == true)
    }

    func testIsLuckyBecauseWeatherHasAnEight() async throws {
        // Given
        let mockWeatherService = MockWeatherService(
            shouldSucceed: true,
            shouldReturnTemperatureWithAnEight: true
        )

        let myLibrary = MyLibrary(weatherService: mockWeatherService)

        // When
        let isLuckyNumber = await myLibrary.isLucky(0)

        // Then
        XCTAssertNotNil(isLuckyNumber)
        XCTAssert(isLuckyNumber == true)
    }

    func testIsNotLucky() async {
        // Given
        let mockWeatherService = MockWeatherService(
            shouldSucceed: true,
            shouldReturnTemperatureWithAnEight: false
        )

        let myLibrary = MyLibrary(weatherService: mockWeatherService)

        // When
        let isLuckyNumber = await myLibrary.isLucky(7)

        // Then
        XCTAssertNotNil(isLuckyNumber)
        XCTAssert(isLuckyNumber == false)
    }

    func testIsNotLuckyBecauseServiceCallFails() async {
        // Given
        let mockWeatherService = MockWeatherService(
            shouldSucceed: false,
            shouldReturnTemperatureWithAnEight: false
        )

        let myLibrary = MyLibrary(weatherService: mockWeatherService)

        // When
        let isLuckyNumber = await myLibrary.isLucky(7)

        // Then
        XCTAssertNil(isLuckyNumber)
    }
    
    func testWeatherTemperature() async {
        //Given
        let jsonString = """
        {
          "main": {
            "temp": 69.4,
            "feels_like": 68.81,
            "temp_min": 67.8,
            "temp_max": 75.11,
            "pressure": 1016,
            "humidity": 59
          }
        }
        """
        
        //When
        let jsonData = Data(jsonString.utf8)
        let jsonDecoder = JSONDecoder()
        let weather = try! jsonDecoder.decode(Weather.self, from: jsonData)
    
        //Then
        XCTAssert(weather.main.temp == 69.4)
        
    }
    
    func testIntegration() async throws {
        //Given
        let myMockServer = WeatherServiceImpl()
        
        //When
        let temp = try await myMockServer.getTemperature()
        
        //Then
        XCTAssertEqual(temp, 286)
    }

}
