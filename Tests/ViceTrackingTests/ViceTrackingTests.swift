import XCTest
@testable import ViceTracking

final class ViceTrackingTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Initialize SDK with test configuration
        ViceTracking.initialize(apiKey: "test-api-key", domain: "viceoffers.com")
        // Clear any stored data
        UserDefaults.standard.removeObject(forKey: "ViceTrackingInstallToken")
        UserDefaults.standard.removeObject(forKey: "ViceTrackingParams")
    }
    
    func testDeepLinkHandling() {
        // Test with install token
        let url = URL(string: "viceoffers://install?token=test-token-123&click_id=456")!
        ViceTracking.handleDeepLink(url)
        
        // Verify token was stored
        XCTAssertEqual(UserDefaults.standard.string(forKey: "ViceTrackingInstallToken"), "test-token-123")
        
        // Verify other parameters were stored
        if let stored = UserDefaults.standard.dictionary(forKey: "ViceTrackingParams") as? [String: String] {
            XCTAssertEqual(stored["token"], "test-token-123")
            XCTAssertEqual(stored["click_id"], "456")
        } else {
            XCTFail("No parameters were stored")
        }
    }
    
    func testEventTrackingWithInstallToken() {
        // First set up an install token
        UserDefaults.standard.set("test-token-123", forKey: "ViceTrackingInstallToken")
        
        let expectation = XCTestExpectation(description: "Event tracking")
        
        ViceTracking.trackEvent("test_event", revenue: 9.99) { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}