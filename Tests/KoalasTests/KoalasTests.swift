import XCTest
@testable import Koalas

final class KoalasTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Koalas().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
