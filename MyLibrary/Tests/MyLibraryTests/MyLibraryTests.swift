import XCTest
@testable import MyLibrary
//import MyLibrary

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
    
    func testGetTemperature() async throws
    {
        //let realWeatherService = WeatherServiceImpl()
        //let myLibrary = MyLibrary(weatherService: realWeatherService)
        
        let jsonString = """
            {
                "main" : {
                    "temp" : 24.71
                }
            }
            """
        
        let jsonData = jsonString.data(using: .utf8)!
        let jsonDecoder = JSONDecoder()
        let weather_test = try jsonDecoder.decode(Weather.self, from: jsonData)
        XCTAssertNotNil(weather_test)
        XCTAssert(weather_test.main.temp == 24.71)
        
        //let weather = try decoder.decode(Weather.self, from: jsonData)

        //Given
        //let mockWeatherService = MockWeatherService(
        //    shouldSucceed: false,
        //    shouldReturnTemperatureWithAnEight: false
        //)
        //let myLibrary = MyLibrary(weatherService: mockWeatherService)
        //let weatherservice = WeatherService(WeatherServiceImpl: mockWeatherService) doesn't work

        //When
        //let isLuckyNumber = await myLibrary.isLucky(7)
    
        //Then
        //XCTAssertNil(isLuckyNumber)

    }
    
    func testIntergration() async throws
    {
        //Given
        let myService = WeatherServiceImpl()

        //When
        let temp = try await myService.getTemperature()

        //Then
        XCTAssertNotNil(temp)
        XCTAssertEqual(temp, 56)
    }

}
