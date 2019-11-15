//
//  System.swift
//  
//
//  Created by Faiçal Tchirou on 31/10/2019.
//

import Foundation

struct System: Shell {
    @discardableResult
    func run(_ command: ShellCommand) -> ShellExecutionResult {
        let process = Process()
        process.launchPath = command.launchPath
        process.arguments = command.arguments
        process.currentDirectoryURL = command.currentDirectoryURL

        guard command.waitUntilExit else {
            process.launch()
            return .success
        }

        let outputPipe = Pipe()
        let errorPipe = Pipe()

        process.standardOutput = outputPipe
        process.standardError = errorPipe
        process.launch()

        let output = String(data: outputPipe.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8)?
            .trimmingCharacters(in: .newlines) ?? ""

        let error = String(data: errorPipe.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8)?
            .trimmingCharacters(in: .newlines) ?? ""

        if var string = String(data: outputPipe.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8) {
            string = string.trimmingCharacters(in: .newlines)
        }

        process.waitUntilExit()

        guard process.terminationStatus == 0 else {
            return .failure(error)
        }

        return .success(output)
    }
}
