//
//  ShellCommand.swift
//  
//
//  Created by Faiçal Tchirou on 31/10/2019.
//

import Foundation

typealias Path = String

enum ShellCommand {
    case open(String)
    case moveDirectory(String, String)
    case removeDirectory(String)
    case getFirstCommit(URL, Path)
    case getCommitDate(URL, GitCommit)
}

extension ShellCommand {
    var launchPath: String {
        switch self {
        case .open:
            return "/usr/bin/open"
        case .moveDirectory:
            return "/bin/mv"
        case .removeDirectory:
            return "/bin/rm"
        case .getFirstCommit:
            return ProcessInfo.processInfo.environment["GIT_PATH"] ?? "/usr/bin/git"
        case .getCommitDate:
            return ProcessInfo.processInfo.environment["GIT_PATH"] ?? "/usr/bin/git"
        }
    }

    var arguments: [String] {
        switch self {
        case let .open(fileName):
            return [fileName]
        case let .moveDirectory(source, destination):
            return [source, destination]
        case let .removeDirectory(path):
            return ["-rf", path]
        case let .getFirstCommit(_, path):
            return ["log", "--diff-filter=A", "--pretty=format:%H", "--", path]
        case let .getCommitDate(_, hash):
            return ["show", "--no-patch", "--no-notes", "--pretty='%aI'", hash]
        }
    }

    var currentDirectoryURL: URL? {
        switch self {
        case .open,
             .moveDirectory,
             .removeDirectory:
            return nil
        case let .getFirstCommit(url, _):
            return url
        case let .getCommitDate(url, _):
            return url
        }
    }

    var waitUntilExit: Bool {
        switch self {
        case .open,
             .moveDirectory,
             .removeDirectory:
            return false
        case .getFirstCommit,
             .getCommitDate:
            return true
        }
    }
}
