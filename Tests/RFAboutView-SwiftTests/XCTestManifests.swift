import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(RFAboutView_SwiftTests.allTests),
    ]
}
#endif
