//
//  CommandParser.swift
//  
//
//  Created by Faiçal Tchirou on 18/10/2019.
//

import Foundation

final class CommandParser {
    private enum Token: String {
        case new
        case make
        case makeAll = "make-all"
        case open
        case openHTML = "open-html"
        case makeIndex = "make-index"
        case list
        case rename
        case remove
        case help = "--help"
    }

    enum Error: Swift.Error {
        case parsingError(String)
    }

    private let arguments: [String]
    private var current = 0

    init(arguments: [String]) {
        self.arguments = arguments
    }

    func parse() throws -> Command {
        advance()

        if accept(.new) {
            return try parseNewCommand()
        }

        if accept(.make) {
            return try parseMakeCommand()
        }

        if accept(.makeAll) {
            return try parseMakeAllCommand()
        }

        if accept(.open) {
            return try parseOpenCommand()
        }

        if accept(.openHTML) {
            return try parseOpenHtmlCommand()
        }

        if accept(.makeIndex) {
            return try parseMakeIndexCommand()
        }

        if accept(.list) {
            return try parseListCommand()
        }

        if accept(.rename) {
            return try parseRenameCommand()
        }

        if accept(.remove) {
            return try parseRemoveCommand()
        }

        return .help(.none)
    }
}

extension CommandParser {
    private func parseNewCommand() throws -> Command {
        try expect(.new)

        if accept(.help) {
            return .help(.new(.none))
        }

        if let id = currentArgument {
            return .new(.withId(id))
        }

        throw Error.parsingError(Command.new(.none).help)
    }

    private func parseMakeCommand() throws -> Command {
        try expect(.make)

        if accept(.help) {
            return .help(.make(.none))
        }

        if let id = currentArgument {
            return .make(.withId(id))
        }

        return .make(.inCurrentDirectory)
    }

    private func parseMakeAllCommand() throws -> Command {
        try expect(.makeAll)

        if accept(.help) {
            return .help(.makeAll)
        }

        return .makeAll
    }

    private func parseOpenCommand() throws -> Command {
        try expect(.open)

        if accept(.help) {
            return .help(.open(.none))
        }

        if let id = currentArgument {
            return .open(.withId(id))
        }

        return .open(.inCurrentDirectory)
    }

    private func parseOpenHtmlCommand() throws -> Command {
        try expect(.openHTML)

        if accept(.help) {
            return .help(.openHTML(.none))
        }

        if let id = currentArgument {
            return .openHTML(.withId(id))
        }

        return .openHTML(.inCurrentDirectory)
    }

    private func parseMakeIndexCommand() throws -> Command {
        try expect(.makeIndex)

        if accept(.help) {
            return .help(.makeIndex)
        }

        return .makeIndex
    }

    private func parseListCommand() throws -> Command {
        try expect(.list)

        if accept(.help) {
            return .help(.list)
        }

        return .list
    }

    private func parseRenameCommand() throws -> Command {
        try expect(.rename)

        if accept(.help) {
            return .help(.rename(.none, .none))
        }

        guard let id = currentArgument else {
            throw Error.parsingError("the id of the article to rename was expected, but not found")
        }

        advance()

        guard let newId = currentArgument else {
            throw Error.parsingError("the new id of the article was expected, but not found")
        }

        return .rename(.withId(id), .withId(newId))
    }

    private func parseRemoveCommand() throws -> Command {
        try expect(.remove)

        if accept(.help) {
            return .help(.remove(.none))
        }

        guard let id = currentArgument else {
            throw Error.parsingError("the id of the article to remove was expected, but not found")
        }

        return .remove(.withId(id))
    }

    private func expect(_ token: Token) throws {
        guard accept(token) else {
            throw Error.parsingError("expected \(token.rawValue) but found \(currentArgument ?? "")")
        }

        advance()
    }

    private func accept(_ token: Token) -> Bool {
        return currentArgument == token.rawValue
    }

    private func advance() {
        current += 1
    }

    private var currentArgument: String? {
        guard current >= 0 && current < arguments.count else {
            return nil
        }

        return arguments[current]
    }
}

extension CommandParser.Error: LocalizedError {
    var errorDescription: String? {
        switch self {
        case let .parsingError(message):
        return message
        }
    }
}
