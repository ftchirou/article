//
//  Shell.swift
//  
//
//  Created by Faiçal Tchirou on 31/10/2019.
//

import Foundation

struct ShellExecutionResult {
    enum Status {
        case success
        case failure
    }

    let status: Status
    let output: String
}

protocol Shell {
    @discardableResult
    func run(_ command: ShellCommand) -> ShellExecutionResult
}

extension ShellExecutionResult {
    static var success: ShellExecutionResult = .init(status: .success, output: "")
    static func success(_ output: String) -> ShellExecutionResult {
        .init(status: .success, output: output)
    }
    static func failure(_ output: String) -> ShellExecutionResult {
        .init(status: .failure, output: output)
    }
}
