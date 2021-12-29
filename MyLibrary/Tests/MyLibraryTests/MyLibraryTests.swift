import XCTest
import MyLibrary

final class MyLibraryTests: XCTestCase {
    func testIsLucky() throws {
        // Given
        let myLibrary = MyLibrary()
        let number = 8

        // When
        let isLuckyNumber = myLibrary.isLucky(number)

        // Then
        XCTAssertTrue(isLuckyNumber)
    }

    func testIsNotLucky() throws {
        // Given
        let myLibrary = MyLibrary()
        let number = 7

        // When
        let isLuckyNumber = myLibrary.isLucky(number)

        // Then
        XCTAssertFalse(isLuckyNumber)
    }
}
