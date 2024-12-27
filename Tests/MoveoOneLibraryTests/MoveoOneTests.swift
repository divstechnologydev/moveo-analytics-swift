import XCTest
@testable import MoveoOneLibrary

final class MoveoOneTests: XCTestCase {
    var sut: MoveoOne!
    
    override func setUp() {
        super.setUp()
        sut = MoveoOne.instance
        sut.initialize(token: "test-token")
        sut.identify(userId: "test-user")
        sut.setLogging(enabled: true)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testStartSessionCreatesNewSession() {
        // Given
        let context = "test-context"
        let metadata = ["key": "value"]
        
        // When
        sut.start(context: context, metadata: metadata)
        
        // Then
        XCTAssertTrue(sut.isStarted()) // You'll need to add this getter
        XCTAssertEqual(sut.getContext(), context) // You'll need to add this getter
    }
    
    func testFlushTimerTriggersAfterInterval() {
        // Given
        let expectation = XCTestExpectation(description: "Flush should be called after interval")
        let flushInterval = 2 // 2 seconds for testing
        sut.setFlushInterval(interval: flushInterval)
        
        // Create a mock service to verify flush was called
        let mockService = MockMoveoOneService()
        MoveoOneService.shared = mockService
        
        // When
        sut.start(context: "test-context", metadata: nil)
        
        // Create test event
        let testData = MoveoOneData(
            semanticGroup: "test-group",
            id: "test-id",
            action: .click,
            type: .button,
            value: "test-value"
        )
        sut.tick(moveoOneData: testData)
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(flushInterval + 1)) {
            XCTAssertTrue(mockService.flushWasCalled)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: Double(flushInterval + 2))
    }
    
    func testMaxThresholdTriggersFlush() {
        // Given
        let mockService = MockMoveoOneService()
        MoveoOneService.shared = mockService
        sut.start(context: "test-context", metadata: nil)
        
        // When
        // Generate events up to threshold
        for _ in 0...500 { // Assuming maxThreshold is 500
            let testData = MoveoOneData(
                semanticGroup: "test-group",
                id: "test-id",
                action: .click,
                type: .button,
                value: "test-value"
            )
            sut.tick(moveoOneData: testData)
        }
        
        // Then
        XCTAssertTrue(mockService.flushWasCalled)
    }
    
    func testMultipleFlushes() {
        // Given
        let mockService = MockMoveoOneService()
        MoveoOneService.shared = mockService
        sut.start(context: "test-context", metadata: nil)
        
        // When
        // First batch of events
        for _ in 0...500 {
            let testData = MoveoOneData(
                semanticGroup: "test-group",
                id: "test-id",
                action: .click,
                type: .button,
                value: "test-value"
            )
            sut.tick(moveoOneData: testData)
        }
        
        // Verify first flush
        XCTAssertEqual(mockService.flushCallCount, 1)
        
        // Add more events after flush
        for _ in 0...100 {
            let testData = MoveoOneData(
                semanticGroup: "test-group-2",
                id: "test-id-2",
                action: .click,
                type: .button,
                value: "test-value-2"
            )
            sut.tick(moveoOneData: testData)
        }
        
        // Force flush
        sut.flush()
        
        // Then
        XCTAssertEqual(mockService.flushCallCount, 2)
    }
}

// Mock Service for testing
private class MockMoveoOneService: MoveoOneService {
    var flushWasCalled = false
    var flushCallCount = 0
    
    override func storeAnalyticsEvent(payload: MoveoOneAnalyticsRequest) async -> Result<String, Error> {
        flushWasCalled = true
        flushCallCount += 1
        return .success("Mock success")
    }
}