import XCTest
@testable import ViceTracking

final class ViceTrackingTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Initialize SDK with test configuration
        ViceTracking.initialize(apiKey: "test-api-key", domain: "viceoffers.com")
    }
    
    func testDeepLinkHandling() {
        let url = URL(string: "viceapp://track?click_id=123&campaign=test")!
        ViceTracking.handleDeepLink(url)
        
        // Verify parameters were stored
        if let stored = UserDefaults.standard.dictionary(forKey: "ViceTrackingParams") as? [String: String] {
            XCTAssertEqual(stored["click_id"], "123")
            XCTAssertEqual(stored["campaign"], "test")
        } else {
            XCTFail("No parameters were stored")
        }
    }
    
    func testEventTracking() {
        let expectation = XCTestExpectation(description: "Event tracking")
        
        ViceTracking.trackEvent("test_event", revenue: 9.99) { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}