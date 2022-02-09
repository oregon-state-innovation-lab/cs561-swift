import XCTest
import MyLibrary

final class MyMockAPITests: XCTestCase {
    
    func testWeather() throws {
        let myLibrary = MyLibrary()
        
        let expectation = XCTestExpectation(description: "We asked about the temperature and heard back 🎄")
        var myTemperature : Int? = nil
        
        // When
        myLibrary.getTemperature(completion: { temperature in
            myTemperature = temperature
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 5)

        // Then
        XCTAssertNotNil(myTemperature)
    }
    
    func testHello() throws {
        let myLibrary = MyLibrary()
        
        let expectation = XCTestExpectation(description: "We asked about the Hola and heard back 🎄")
        var myHola : String? = nil
        
        // When
        myLibrary.getHola(completion: { Hola in
            myHola = Hola
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 5)

        // Then
        XCTAssertNotNil(myHola)
    }

}

