//
//  ShellMock.swift
//  
//
//  Created by Faiçal Tchirou on 31/10/2019.
//

import Foundation

@testable import articleCore

class ShellMock: Shell {
    private var opened: [String] = []
    private var removed: [String] = []
    private var moved: [(String, String)] = []

    @discardableResult
    func run(_ command: ShellCommand) -> ShellExecutionResult {
        switch command {
        case let .open(path):
            opened.append(path)
        case let .moveDirectory(from, to):
            moved.append((from, to))
        case let .removeDirectory(path):
            removed.append(path)
        default:
            break
        }

        return .success
    }

    func didOpen(_ path: String) -> Bool {
        return opened.contains(path)
    }

    func didRemove(_ path: String) -> Bool {
        return removed.contains(path)
    }

    func didMove(_ from: String, _ to: String) -> Bool {
        return moved.contains(where: { $0.0 == from && $0.1 == to })
    }
}
