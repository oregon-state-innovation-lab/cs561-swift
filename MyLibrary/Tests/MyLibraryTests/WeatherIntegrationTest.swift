//
//  WeatherIntegrationTest.swift
//  
//
//  Created by Rudrajit Choudhuri on 10/14/22.
//

@testable import MyLibrary
import XCTest

final class WeatherIntegrationTest: XCTestCase {
    func testIsWeatherTemp() async {
        let weather = WeatherServiceImpl()
        // Fetch the current weather from the backend.
        do {
            let temperature = try await weather.getTemperature()
            XCTAssertNotNil(temperature)
        } catch {
            print("Temperature is not returned")
        }
    }
}
