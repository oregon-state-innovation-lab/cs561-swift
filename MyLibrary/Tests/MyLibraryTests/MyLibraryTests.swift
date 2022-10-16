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
    
    func testWeatherModel() throws {
        let jsonString = """
        {"coord":{"lon":-123.262,"lat":44.5646},"weather":[{"id":800,"main":"Clear","description":"clear sky","icon":"01d"}],"base":"stations","main":{"temp":73.8,"feels_like":72.34,"temp_min":70.27,"temp_max":75.24,"pressure":1014,"humidity":31,"sea_level":1014,"grnd_level":1006},"visibility":10000,"wind":{"speed":3.71,"deg":247,"gust":5.12},"clouds":{"all":0},"dt":1665951478,"sys":{"type":2,"id":2002508,"country":"US","sunrise":1665930569,"sunset":1665970039},"timezone":-25200,"id":5720727,"name":"Corvallis","cod":200}
        """
        // create json data from json strong
        let jsonData = Data(jsonString.utf8)
        
        // create JSON decoder
        let jsonDecoder = JSONDecoder()
    
        // deserialize data into a model
        let weather = try jsonDecoder.decode(Weather.self, from: jsonData)
        
        // assert weather model
        XCTAssertTrue(type(of: weather) == Weather.self)
    }
    
}

final class MyLibraryIntegrationTests: XCTestCase {
    func testWeatherServiceImpl() async throws {
        // Given
        let weatherServiceImpl = WeatherServiceImpl()
        // When
        let weather = try await weatherServiceImpl.getTemperature()
        // Then
        XCTAssertNotNil(weather)
        XCTAssertTrue(type(of: weather) == Int.self)
    }
}
