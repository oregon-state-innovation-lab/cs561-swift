import XCTest
@testable import MyLibrary

final class ITests: XCTestCase {
    func test_IT_mock() async throws {
        // Given
        let my_library = MyLibrary()
        // When
        let is_lucky_number = await my_library.isLucky(0)
        // Then 
        XCTAssertNotNil(is_lucky_number)

        //SHOULD RETURN FALSE HEREi so this pass
        XCTAssert(is_lucky_number == false)
    }
    

    func test_IT_prod() async throws {
        // Given
        let prod_weather_service = WeatherServiceImpl(prod: true)
        let my_library = MyLibrary(weatherService: prod_weather_service)
        // When
        let is_lucky_number = await my_library.isLucky(0)
        // Then
        // Weather changes so not sure what to expect here
        // but yeah, can't really know the result
        XCTAssertNotNil(is_lucky_number)
    }
}


