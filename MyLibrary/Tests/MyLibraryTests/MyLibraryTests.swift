import XCTest
import MyLibrary
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

    func testIncreaseCodeCoverage() async {
        let myLibrary = MyLibrary(weatherService: nil)

        let isLuckyNumber = await myLibrary.isLucky(7)

        // Then, only to avoid warning
        XCTAssert(isLuckyNumber != nil)
    }

    func testGetTemp() async throws {
        // Expected output
        let filePath = try XCTUnwrap(Bundle.module.path(forResource:"getWeatherExp", ofType: "json"))
        let jsonString = try String(contentsOfFile: filePath)
        let jsonData = Data(jsonString.utf8)
        let jsonDecoder = JSONDecoder()
        
        let weather = try jsonDecoder.decode(Weather.self, from: jsonData)
        let expOut = Int(weather.main.temp)

        // Actual Output
        let weatherServiceObj = WeatherServiceImpl(url: nil)
        
        do {
            let actOut = try await weatherServiceObj.getTemperature()
            XCTAssertEqual(expOut, actOut)
        } catch {
            XCTAssert(false)
        }
    }
    
    func testGetTempFail() async throws {
        let weatherServiceObj = WeatherServiceImpl(url: "http://localhost/data/2.5/temperature/lat=10.12&lon=20&appid=dontknow")
        
        do {
            let actOut = try await weatherServiceObj.getTemperature()
            print(actOut)
            XCTAssert(false)
        } catch {
            XCTAssert(true)
        }
    }
    
    func testIntegration() async throws {
        let myLibrary = MyLibrary(weatherService: nil)

        let isLuckyNumber = await myLibrary.isLucky(0)

        XCTAssert(isLuckyNumber == false)
    }
}
