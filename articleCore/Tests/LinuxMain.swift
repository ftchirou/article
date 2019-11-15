import XCTest
import articleTests

var tests = [XCTestCaseEntry]()
tests += CommandParserTests.allTests()
tests += CommandTests.allTests()
XCTMain(tests)
