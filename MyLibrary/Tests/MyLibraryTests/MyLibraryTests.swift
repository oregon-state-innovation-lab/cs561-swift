import XCTest
import MyLibrary

final class MyLibraryTests: XCTestCase {
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

    func testAuth() throws {
        // Given

        let myLibrary = MyLibrary()
        let expectation = XCTestExpectation(description: "We asked about the access token and get jwt token")
        var jwt : String?

        // When
        myLibrary.getAuth(completion: { token in
            print("================")
            print(token as Any)
            jwt = token
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 5)

        // Then
        XCTAssertNotNil(jwt)
    }
    
    func testv1Weather() throws {
        // Given

        let myLibrary = MyLibrary()
        let expectation = XCTestExpectation(description: "We asked about weather data by using jwt token")
        var temp : String?

        // When
        myLibrary.getWeather(completion: { res in
            print("================Corvallis temperature===============")
            print(res as Any)
            temp = res
            print("===================finished test====================")
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 5)

        // Then
        XCTAssertNotNil(temp)
    }
    
    func testv1Hello() throws {
        // Given

        let myLibrary = MyLibrary()
        let expectation = XCTestExpectation(description: "We asked about weather data by using jwt token")
        var message : String?

        // When
        myLibrary.getHello(completion: { res in
            print("================message===============")
            print(res as Any)
            message = res
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 5)

        // Then
        XCTAssertNotNil(message)
    }
}
