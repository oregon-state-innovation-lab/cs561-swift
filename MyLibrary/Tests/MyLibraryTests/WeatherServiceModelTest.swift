import XCTest
import MyLibrary

final class WeatherServiceTests: XCTestCase {
    
    private func getWeatherJson() throws -> String {
        let file = try XCTUnwrap(Bundle.module.path(forResource: "data", ofType: "json"))
        let jsonString = try String(contentsOfFile: file)
        
        return jsonString
    }
    
    // Test if we are able serialize the json to weather object.
    func testWeatherServiceModel_canDeserializeObject() throws {
        // Given
        let jsonString = try getWeatherJson()
        let jsonData = Data(jsonString.utf8)
        let jsonDecoder = JSONDecoder()
        
        // When
        let weather = try jsonDecoder.decode(Weather.self, from: jsonData)
        
        
        // Then
        XCTAssertNotNil(weather)
    }
    
    // Negative test to test if JSON is invalid, it throws error.
    func testWeatherServiceModel_invalidJSON() throws {
        // Given
        let jsonString = try getWeatherJson() + "adding string to make json Invalid."
        let jsonData = Data(jsonString.utf8)
        let jsonDecoder = JSONDecoder()
        
        // When
        let isErrorReturned: Bool
        do {
            let weather = try jsonDecoder.decode(Weather.self, from: jsonData)
            isErrorReturned = false
        } catch {
            isErrorReturned = true
        }
        
        // Then
        XCTAssertTrue(isErrorReturned)
    }
}
