import XCTest
import MyLibrary


final class MyLibraryTests: XCTestCase {
    
    func testHello() throws {
        
        var returnedGreetings: String?
        var myToken: String?
        var returnedWeather: String?

        let myLibrary = MyLibrary()
        let expectation1 = XCTestExpectation(description: "We asked about the number 8 and heard back 🎄")
        let expectation2 = XCTestExpectation(description: "We asked about the number 8 and heard back 🎄")
        let expectation3 = XCTestExpectation(description: "We asked about the number 8 and heard back 🎄")
       
        myLibrary.printToken { token in
            myToken = token
            expectation1.fulfill()
        }
        wait(for: [expectation1], timeout: 5)
        
        XCTAssertNotNil(myToken)
        XCTAssert(myToken == "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkthcmwgQWRyaWFubyIsImlhdCI6MTUxNjIzOTAyMn0.STyNSCjMt9cKNL6YVfLRTBabPbzbW1FDRebDqTwC2-c")
        
        
        myLibrary.printWeather(token: myToken ?? "") { weathers in
            returnedWeather = weathers
            expectation3.fulfill()
        }
        wait(for: [expectation3], timeout: 5)
        
        XCTAssertNotNil(returnedWeather)
        XCTAssert(returnedWeather == "stations")
        
        
        myLibrary.printGreetings(token: myToken ?? "") { greeting in
            returnedGreetings = greeting
            expectation2.fulfill()
        }
        wait(for: [expectation2], timeout: 5)
        
        XCTAssertNotNil(returnedGreetings)
        XCTAssert(returnedGreetings == "Greetings to you all!")
        
    }
    
    
    
    
    
    
    
    func testIsLuckyBecauseWeAlreadyHaveLuckyNumber() throws {
        // Given
        let mockWeatherService = MockWeatherService(
            shouldSucceed: true,
            shouldReturnTemperatureWithAnEight: false
        )

        let myLibrary = MyLibrary(weatherService: mockWeatherService)
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
    /////

    func testIsLuckyBecauseWeatherHasAnEight() throws {
        // Given
        let mockWeatherService = MockWeatherService(
            shouldSucceed: true,
            shouldReturnTemperatureWithAnEight: true
        )

        let myLibrary = MyLibrary(weatherService: mockWeatherService)
        let number = 0
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
        let mockWeatherService = MockWeatherService(
            shouldSucceed: true,
            shouldReturnTemperatureWithAnEight: false
        )

        let myLibrary = MyLibrary(weatherService: mockWeatherService)
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

    func testIsNotLuckyBecauseServiceCallFails() throws {
        // Given
        let mockWeatherService = MockWeatherService(
            shouldSucceed: false,
            shouldReturnTemperatureWithAnEight: false
        )

        let myLibrary = MyLibrary(weatherService: mockWeatherService)
        let number = 7
        let expectation = XCTestExpectation(description: "We asked about the number 7 but the service call failed 🤖💩")
        var isLuckyNumber: Bool?

        // When
        myLibrary.isLucky(number, completion: { lucky in
            isLuckyNumber = lucky
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 5)

        // Then
        XCTAssertNil(isLuckyNumber)
    }

}
