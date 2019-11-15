import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(CommandParserTests.allTests),
        testCase(CommandTests.allTests)
    ]
}
#endif
