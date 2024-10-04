import XCTest

#if !canImport(ObjectiveC)
  public func allTests() -> [XCTestCaseEntry] {
    return [
      testCase(TerminalUITests.allTests)
    ]
  }
#endif
