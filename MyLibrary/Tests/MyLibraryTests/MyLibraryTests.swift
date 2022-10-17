import XCTest
// import MyLibrary
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

    func test_shivani() async {
        let infoData = """
        {
            "coord":{"lon":-123.262,"lat":44.5646},"weather":[{"id":721,"main":"Haze","description":"haze","icon":"50d"}],"base":"stations","main":{"temp":291.18,"feels_like":290.92,"temp_min":291.18,"temp_max":294.1,"pressure":1022,"humidity":72},"visibility":8047,"wind":{"speed":0,"deg":0},"clouds":{"all":0},"dt":1665173713,"sys":{"type":1,"id":3727,"country":"US","sunrise":1665152291,"sunset":1665193391},"timezone":-25200,"id":5720727,"name":"Corvallis","cod":200
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        // when
        let information = try! decoder.decode(Weather.self, from: infoData)
        // Then
        XCTAssertNotNil(information.main.temp)
        XCTAssert(information.main.temp == 291.18)
    }
    
}
