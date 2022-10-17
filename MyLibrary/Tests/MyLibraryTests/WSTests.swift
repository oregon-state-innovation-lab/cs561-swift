import XCTest
@testable import MyLibrary

final class WSTests: XCTestCase {
    func test_weather_model_0kelvin() async throws {
        // Given
        let file_path = try XCTUnwrap(Bundle.module.path(forResource: "api_data", ofType: "json"))
        
        //stuff from deserializing hint
        let json_string = try String (contentsOfFile: file_path)

        let json_data = Data (json_string.utf8)
        
        let json_decoder = JSONDecoder()

        // When
        let weather = try json_decoder.decode(Weather.self, from: json_data)

        // Then
        XCTAssertNotNil(weather)
        // Kelvin is default. 0 Kelvin is physically impossible
        // Thus there must be an error
        XCTAssert(weather.main.temp != 0)
    }
    func test_weather_model_for_mock_values() async throws {
        // Given
        let file_path = try XCTUnwrap(Bundle.module.path(forResource: "api_data", ofType: "json"))

        //stuff from deserializing hint
        let json_string = try String (contentsOfFile: file_path)

        let json_data = Data (json_string.utf8)

        let json_decoder = JSONDecoder()

        // When
        let weather = try json_decoder.decode(Weather.self, from: json_data)

        // Then
        XCTAssertNotNil(weather)
        XCTAssert(weather.main.temp != 286.71)
    }
    func test_weather_model_for_negative() async throws {
        // Given
        let file_path = try XCTUnwrap(Bundle.module.path(forResource: "api_data", ofType: "json"))

        //stuff from deserializing hint
        let json_string = try String (contentsOfFile: file_path)

        let json_data = Data (json_string.utf8)

        let json_decoder = JSONDecoder()

        // When
        let weather = try json_decoder.decode(Weather.self, from: json_data)

        // Then
        // negative Kelvin is pretty much impossible
        XCTAssertNotNil(weather)
        XCTAssert(weather.main.temp < 0)
    }
}
