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

    func testunittest() async{

            let jasonString = """
             { 
                "coord": {
            "lon": -123.2785,
            "lat": 44.5672
          },
          "weather": [
            {
              "id": 804,
              "main": "Clouds",
              "description": "overcast clouds",
              "icon": "04d"
            }
          ],
          "base": "stations",
          "main": {
            "temp": 286.6,
            "feels_like": 285.91,
            "temp_min": 285.88,
            "temp_max": 289.25,
            "pressure": 1021,
            "humidity": 73
          },
          "visibility": 10000,
          "wind": {
            "speed": 4.12,
            "deg": 10
          },
          "clouds": {
            "all": 100
          },
          "dt": 1664556726,
          "sys": {
            "type": 2,
            "id": 2040223,
            "country": "US",
            "sunrise": 1664546987,
            "sunset": 1664589370
          },
          "timezone": -25200,
          "id": 5720727,
          "name": "Corvallis",
          "cod": 200
        }
        """

        let data = Data(jasonString.utf8)

        do {
            let jsonData = try JSONDecoder() .decode(Weather.self, from: data)
            XCTAssertEqual(jsonData.main.temp, 286.6)
        }catch{
            XCTAssert(false)
        }       
    }

    func testWeatherService() async throws {
        let weatherService = WeatherServiceImpl()

        let temp = try await weatherService.getTemperature()
        
       
        XCTAssertNotNil(temp)
      
       XCTAssert(temp == 54)
    }


}
