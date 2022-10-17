import XCTest
import MyLibrary

final class WeatherServiceImplTests: XCTestCase {
    
    func testweatherSeriveTest_canGetTemperature() async throws {
        // Given
        let temperatureToBeReturned = 38.9
        let weatherServiceMockBaseUrl = "http://127.0.0.1:5000"
        let weatherSerivce = WeatherServiceImpl(baseUrl: weatherServiceMockBaseUrl)
        
        // When
        let temperature = try await weatherSerivce.getTemperature()
        
        // Then
        XCTAssertNotNil(temperature)
        XCTAssertEqual(temperature, Int(temperatureToBeReturned))
    }
    
    func testweatherSeriveTest_failedGetTemperatureError500() async throws {
        // Given
        let returnedErrorDescription = "Response status code was unacceptable: 500."
        let weatherServiceMockBaseUrl = "http://127.0.0.1:5000"
        let weatherSerivce = WeatherServiceImpl(baseUrl: weatherServiceMockBaseUrl, city: "")
        var isErrorReturned: Bool
        var errorDescription = ""
        
        // When
        do {
            let temperature = try await weatherSerivce.getTemperature()
            isErrorReturned = false
        } catch {
            errorDescription = error.localizedDescription
            isErrorReturned = true
        }
        
        // Then
        XCTAssertTrue(isErrorReturned)
        XCTAssertEqual(errorDescription, returnedErrorDescription)
    }
    
    func testweatherSeriveTest_failedGetTemperatureError404() async throws {
        // Given
        let returnedErrorDescription = "URLSessionTask failed with error: Could not connect to the server."
        let weatherServiceMockBaseUrl = "http://127.0.0.1:1234" // Wrong Url to get 404
        let weatherSerivce = WeatherServiceImpl(baseUrl: weatherServiceMockBaseUrl)
        var isErrorReturned: Bool
        var errorDescription = ""
        
        // When
        do {
            let temperature = try await weatherSerivce.getTemperature()
            isErrorReturned = false
        } catch {
            errorDescription = error.localizedDescription
            isErrorReturned = true
        }
        
        // Then
        XCTAssertTrue(isErrorReturned)
        XCTAssertEqual(errorDescription, returnedErrorDescription)
    }
}
