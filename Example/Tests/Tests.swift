import AppEventTracker
import XCTest

class Tests: XCTestCase {

    class MockViewController: UIViewController { }

    func testViewDidLoadHook() {

        let expectation = self.expectation(description: "Hook is called")
        expectation.expectedFulfillmentCount = 2

        var hookVC: UIViewController?
        AppEventTracker.configure(size: 10) {_, data in
            hookVC = data as? UIViewController
            expectation.fulfill()
        }
        AppEventTracker.enableViewDidLoad()

        let uiVC = UIViewController()
        uiVC.viewDidLoad()

        XCTAssertEqual(hookVC, uiVC)

        XCTAssertEqual(1, AppEventTracker.events.count)
        XCTAssertEqual("UIViewController", AppEventTracker.events[0].name)
        XCTAssertEqual(.viewDidLoad, AppEventTracker.events[0].type)

        let mockVC = MockViewController()
        mockVC.viewDidLoad()

        XCTAssertEqual(2, AppEventTracker.events.count)
        XCTAssertEqual("MockViewController", AppEventTracker.events[1].name)
        XCTAssertEqual(.viewDidLoad, AppEventTracker.events[1].type)

        wait(for: [expectation], timeout: 3)
    }

    func testBufferSizeWithoutConfigure() {
        XCTAssertEqual(0, AppEventTracker.events.count)
    }

    func testFixedSizedBuffer() {

        var buffer = FixedSizeBuffer<Int>(count: 5)
        buffer.push(1)
        XCTAssertEqual([nil, nil, nil, nil, 1], buffer.list)
        buffer.push(2)
        XCTAssertEqual([nil, nil, nil, 1, 2], buffer.list)
        buffer.push(3)
        XCTAssertEqual([nil, nil, 1, 2, 3], buffer.list)
        buffer.push(4)
        XCTAssertEqual([nil, 1, 2, 3, 4], buffer.list)
        buffer.push(5)
        XCTAssertEqual([1, 2, 3, 4, 5], buffer.list)
        buffer.push(6)
        XCTAssertEqual([2, 3, 4, 5, 6], buffer.list)
    }
}
