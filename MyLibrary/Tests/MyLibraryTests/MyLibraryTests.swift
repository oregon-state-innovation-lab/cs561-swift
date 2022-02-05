import XCTest
import MyLibrary

final class MyLibraryTests: XCTestCase {
    func testWeather() throws {
        /*
         Narrow integration test using getTemp function of MyLibrary to return current temperature
         The URL is currently hardcoded in WeatherServices to point to the localhost
         An instance of apimocker needs to be running, the config json for that hard codes the
         current temperature at 43 degrees
         */
        // Given
        let myLibrary = MyLibrary()
        let expectation = XCTestExpectation(description: "We asked about the number 7 and heard back 🎄")
        var temperature: Int?

        // When
        myLibrary.getTemp(completion: { temp in
            temperature = temp
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 5)

        // Then
        XCTAssert(temperature == 45)
    }

    func testHello() throws {
        // Given
        let myLibrary = MyLibrary()
        let expectation = XCTestExpectation(description: "We asked about the number 7 and heard back 🎄")
        var message: String?

        // When
        myLibrary.getMessage(completion: { msg in
            message = msg
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 5)


        // Then

        XCTAssert(message == "Hello world!")
    }
}
