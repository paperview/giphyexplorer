import XCTest
@testable import GiphyLib

final class GiphyLibTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(GiphyLib().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
