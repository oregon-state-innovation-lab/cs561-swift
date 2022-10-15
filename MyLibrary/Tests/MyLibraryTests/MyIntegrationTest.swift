//  Created by 김원종 on 10/15/22.
//
import XCTest
import MyLibrary
@testable import MyLibrary

final class MyIntegrationTest: XCTestCase {
    
    func testWeather() async throws {
        // Given
        // Create a weather service
        let myService = WeatherServiceImpl()
        
        // When
        // Got the temperature
        let temp = try await myService.getTemperature()
        // Then
        // Check the temperature is what you expect
        
        XCTAssertEqual(temp, 83)
    }
}
