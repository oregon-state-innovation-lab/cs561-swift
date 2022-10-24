import XCTest
import MyLibrary
@testable import MyLibrary

final class IntergrationTest: XCTestCase
{

func Integrationtest1() async throws{
    //given
    let weatherserv = WeatherServiceImpl()
    //when
    let temperature = try await weatherserv.getTemperature()
    //then
    XCTAssertEqual(temperature,55)
}
func Integrationtest2() async throws{
    //given
    let weatherserv = WeatherServiceImpl()
    //when
    let temperature = try await weatherserv.getTemperature()
    //then
    XCTAssert((temperature as Any) is Int)
}
}
final class MyLibraryTests: XCTestCase {
    

    func CheckTemperature() throws {
        //given
        let filePath = try XCTUnwrap(Bundle.module.path(forResource:"data",ofType:"json"))
        let jsonString = try String(contentsOfFile: filePath)
        let jsonData = Data(jsonString.utf8)
        let jsonDecoder = JSONDecoder()

        // When
        let weather = try jsonDecoder.decode(Weather.self, from: jsonData)
        print(weather.main.temp)

        //Then
        XCTAssertNotNil(weather.main.temp)
    }

        func CheckFilePath() throws {
        //given
        let filePath = try XCTUnwrap(Bundle.module.path(forResource:"data",ofType:"json"))
        let jsonString = try String(contentsOfFile: filePath)
        let jsonData = Data(jsonString.utf8)
        let jsonDecoder = JSONDecoder()

        // When
        let weather = try jsonDecoder.decode(Weather.self, from: jsonData)
        print(weather.main.temp)

        //Then
        XCTAssertNotNil(filePath)
    }

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

}