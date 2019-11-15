//
//  CommandParserTests.swift
//  
//
//  Created by Faiçal Tchirou on 29/10/2019.
//

import XCTest
@testable import articleCore

class CommandParserTests: XCTestCase {
    func testParseNewCommand() throws {
        let arguments = ["article", "new", "hello-world"]
        let parser = CommandParser(arguments: arguments)
        let command = try parser.parse()

        XCTAssertEqual(command, .new(.withId("hello-world")))
    }

    func testParseNewCommandThrowsErrorIfArticleIdIsMissing() {
        let arguments = ["article", "new"]
        let parser = CommandParser(arguments: arguments)

        try XCTAssertThrowsError(parser.parse(), "") {
            XCTAssertTrue($0 is CommandParser.Error)
        }
    }

    func testParseHelpNewCommand() throws {
        let arguments = ["article", "new", "--help"]
        let parser = CommandParser(arguments: arguments)
        let command = try parser.parse()

        XCTAssertEqual(command, .help(.new(.none)))
    }

    func testParseMakeCommand() throws {
        let arguments = ["article", "make", "hello-world"]
        let parser = CommandParser(arguments: arguments)
        let command = try parser.parse()

        XCTAssertEqual(command, .make(.withId("hello-world")))
    }

    func testParseMakeAllCommand() throws {
        let arguments = ["article", "make-all"]
        let parser = CommandParser(arguments: arguments)
        let command = try parser.parse()

        XCTAssertEqual(command, .makeAll)
    }

    func testParseMakeInCurrentDirectoryCommand() throws {
        let arguments = ["article", "make"]
        let parser = CommandParser(arguments: arguments)
        let command = try parser.parse()

        XCTAssertEqual(command, .make(.inCurrentDirectory))
    }

    func testParseHelpMakeCommand() throws {
        let arguments = ["article", "make", "--help"]
        let parser = CommandParser(arguments: arguments)
        let command = try parser.parse()

        XCTAssertEqual(command, .help(.make(.none)))
    }

    func testParseOpenCommand() throws {
        let arguments = ["article", "open", "hello-world"]
        let parser = CommandParser(arguments: arguments)
        let command = try parser.parse()

        XCTAssertEqual(command, .open(.withId("hello-world")))
    }

    func testParseOpenInCurrentDirectoryCommand() throws {
        let arguments = ["article", "open"]
        let parser = CommandParser(arguments: arguments)
        let command = try parser.parse()

        XCTAssertEqual(command, .open(.inCurrentDirectory))
    }

    func testParseHelpOpenCommand() throws {
        let arguments = ["article", "open", "--help"]
        let parser = CommandParser(arguments: arguments)
        let command = try parser.parse()

        XCTAssertEqual(command, .help(.open(.none)))
    }

    func testParseOpenHTMLCommand() throws {
        let arguments = ["article", "open-html", "hello-world"]
        let parser = CommandParser(arguments: arguments)
        let command = try parser.parse()

        XCTAssertEqual(command, .openHTML(.withId("hello-world")))
    }

    func testParseOpenHTMLInCurrentDirectoryCommand() throws {
        let arguments = ["article", "open-html"]
        let parser = CommandParser(arguments: arguments)
        let command = try parser.parse()

        XCTAssertEqual(command, .openHTML(.inCurrentDirectory))
    }

    func testParseHelpOpenHTMLCommand() throws {
        let arguments = ["article", "open-html", "--help"]
        let parser = CommandParser(arguments: arguments)
        let command = try parser.parse()

        XCTAssertEqual(command, .help(.openHTML(.none)))
    }

    func testParseMakeIndexCommand() throws {
        let arguments = ["article", "make-index"]
        let parser = CommandParser(arguments: arguments)
        let command = try parser.parse()

        XCTAssertEqual(command, .makeIndex)
    }

    func testParseHelpMakeIndex() throws {
        let arguments = ["article", "make-index", "--help"]
        let parser = CommandParser(arguments: arguments)
        let command = try parser.parse()

        XCTAssertEqual(command, .help(.makeIndex))
    }

    func testParseListCommand() throws {
        let arguments = ["article", "list"]
        let parser = CommandParser(arguments: arguments)
        let command = try parser.parse()

        XCTAssertEqual(command, .list)
    }

    func testParseHelpList() throws {
        let arguments = ["article", "list", "--help"]
        let parser = CommandParser(arguments: arguments)
        let command = try parser.parse()

        XCTAssertEqual(command, .help(.list))
    }

    func testParseRenameCommand() throws {
        let arguments = ["article", "rename", "old-name", "new-name"]
        let parser = CommandParser(arguments: arguments)
        let command = try parser.parse()

        XCTAssertEqual(command, .rename(.withId("old-name"), .withId("new-name")))
    }

    func testParseHelpRenameCommand() throws {
        let arguments = ["article", "rename", "--help"]
        let parser = CommandParser(arguments: arguments)
        let command = try parser.parse()

        XCTAssertEqual(command, .help(.rename(.none, .none)))
    }

    func testParseRenameCommandThrowsErrorIfNoArticleIdIsProvided() {
        let arguments = ["article", "rename"]
        let parser = CommandParser(arguments: arguments)

        try XCTAssertThrowsError(parser.parse(), "") { error in
            XCTAssertTrue(error is CommandParser.Error)
        }
    }

    func testParseRenameCommandThrowsErrorIfOnlyOneArticleIdIsProvided() {
        let arguments = ["article", "rename", "old-name"]
        let parser = CommandParser(arguments: arguments)

        try XCTAssertThrowsError(parser.parse(), "") { error in
            XCTAssertTrue(error is CommandParser.Error)
        }
    }

    func testParseRemoveCommand() throws {
        let arguments = ["article", "remove", "hello-world"]
        let parser = CommandParser(arguments: arguments)
        let command = try parser.parse()

        XCTAssertEqual(command, .remove(.withId("hello-world")))
    }

    func testParseRemoveCommandThrowsErrorIfArticleIdIsMissing() throws {
        let arguments = ["article", "remove"]
        let parser = CommandParser(arguments: arguments)

        try XCTAssertThrowsError(parser.parse(), "") { error in
            XCTAssertTrue(error is CommandParser.Error)
        }
    }

    func testParseHelpRemoveCommand() throws {
        let arguments = ["article", "remove", "--help"]
        let parser = CommandParser(arguments: arguments)
        let command = try parser.parse()

        XCTAssertEqual(command, .help(.remove(.none)))
    }
}

extension CommandParserTests {
    static var allTests = [
        ("testParseNewCommand\\", testParseNewCommand),
        ("testParseNewCommandThrowsErrorIfArticleIdIsMissing\\", testParseNewCommandThrowsErrorIfArticleIdIsMissing),
        ("testParseHelpNewCommand\\", testParseHelpNewCommand),
        ("testParseMakeCommand\\", testParseMakeCommand),
        ("testParseMakeInCurrentDirectoryCommand\\", testParseMakeInCurrentDirectoryCommand),
        ("testParseHelpMakeCommand\\", testParseHelpMakeCommand),
        ("testParseOpenCommand\\", testParseOpenCommand),
        ("testParseOpenInCurrentDirectoryCommand\\", testParseOpenInCurrentDirectoryCommand),
        ("testParseHelpOpenCommand\\", testParseHelpOpenCommand),
        ("testParseOpenHTMLCommand\\", testParseOpenHTMLCommand),
        ("testParseOpenHTMLInCurrentDirectoryCommand\\", testParseOpenHTMLInCurrentDirectoryCommand),
        ("testParseHelpOpenHTMLCommand\\", testParseHelpOpenHTMLCommand),
        ("testParseMakeIndexCommand\\", testParseMakeIndexCommand),
        ("testParseHelpMakeIndex\\", testParseHelpMakeIndex),
        ("testParseListCommand\\", testParseListCommand),
        ("testParseHelpList\\", testParseHelpList),
        ("testParseRenameCommand\\", testParseRenameCommand),
        ("testParseHelpRenameCommand\\", testParseHelpRenameCommand),
        ("testParseRenameCommandThrowsErrorIfNoArticleIdIsProvided\\", testParseRenameCommandThrowsErrorIfNoArticleIdIsProvided),
        ("testParseRenameCommandThrowsErrorIfOnlyOneArticleIdIsProvided\\", testParseRenameCommandThrowsErrorIfOnlyOneArticleIdIsProvided),
        ("testParseRemoveCommand\\", testParseRemoveCommand),
        ("testParseRemoveCommandThrowsErrorIfArticleIdIsMissing\\", testParseRemoveCommandThrowsErrorIfArticleIdIsMissing),
        ("testParseHelpRemoveCommand\\", testParseHelpRemoveCommand)
    ]
}
