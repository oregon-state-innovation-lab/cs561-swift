import XCTest
import MyLibrary

final class MockAPITests: XCTestCase {

    func testWeather() throws {
        let myLibrary = MyLibrary()

        let expectation = XCTestExpectation(description: "We asked about the temperature and heard back 🎄")
        var myTemperature : Int? = nil

        // When
        myLibrary.getTemperature(completion: { temperature in
            myTemperature = temperature;
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 5)

        // Then
        XCTAssertNotNil(myTemperature)
    }

    func testHello() throws {
        let myLibrary = MyLibrary()

        let expectation = XCTestExpectation(description: "Response received")
        var helloResponse : String? = nil

        // When
        myLibrary.getHello(completion: { greeting in
            helloResponse = greeting
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 5)

        // Then
        XCTAssertNotNil(helloResponse)
    }

}
