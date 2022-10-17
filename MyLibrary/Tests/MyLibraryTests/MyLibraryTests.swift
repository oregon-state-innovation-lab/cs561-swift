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
    
    func testWeatherDecoderPass() throws{
        let weatherData = """
        {
            "main":{
                "temp": "30.2"
        }
        """.data(using: .utf8)!
        do{
            let jsonToString = JSONDecoder()
            let data = try jsonToString.decode(Weather.self, from: weatherData)
            XCTAssertNotNil(data.main.temp)
            
        }
        catch{
            print("Failed. Error: ", error)
        }
    }
    
    func testWeatherDecoderFail() throws{
        let weatherData = """
        {
            "web":{
                "req": "12"
        }
        """.data(using: .utf8)!
        do{
            let jsonToString = JSONDecoder()
            let data = try jsonToString.decode(Weather.self, from: weatherData)
            XCTAssertNotNil(data.main.temp)
            
        }
        catch{
            print("Failed. Error: ", error)
        }
    }
}
