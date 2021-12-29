import XCTest
import MyLibrary

final class MyLibraryTests: XCTestCase {
    func testIsLucky() throws {
        // Given
        let myLibrary = MyLibrary()
        let number = 8
        let expectation = XCTestExpectation(description: "We asked about the number 8 and heard back 🎄")
        var isLuckyNumber: Bool?

        // When
        myLibrary.isLucky(number, completion: { lucky in
            isLuckyNumber = lucky
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 5)

        // Then
        XCTAssertNotNil(isLuckyNumber)
        XCTAssert(isLuckyNumber == true)
    }

    func testIsNotLucky() throws {
        // Given
        let myLibrary = MyLibrary()
        let number = 7
        let expectation = XCTestExpectation(description: "We asked about the number 7 and heard back 🌲")
        var isLuckyNumber: Bool?

        // When
        myLibrary.isLucky(number, completion: { lucky in
            isLuckyNumber = lucky
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 5)

        // Then
        XCTAssertNotNil(isLuckyNumber)
        XCTAssert(isLuckyNumber == false)
    }
}
