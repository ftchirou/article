//
//  FilesMock.swift
//  
//
//  Created by Faiçal Tchirou on 30/10/2019.
//

import Foundation

@testable import articleCore

class FilesMock: Files {
    struct Directory {
        let path: String
        let creationDate: Date
    }

    private var directories: [URL: Directory] = [:]
    private var files: [URL: String] = [:]

    var blogSourceDirectoryURL: URL {
        URL(fileURLWithPath: "source")
    }

    var blogBuildDirectoryURL: URL {
        URL(fileURLWithPath: "build")
    }

    var blogTrashDirectoryURL: URL? {
        URL(fileURLWithPath: "trash")
    }

    var blogIndexURL: URL {
        URL(fileURLWithPath: "build/index.html")
    }

    var currentDirectoryPath: String {
        "currentDirectory"
    }

    func directoryExists(at url: URL) -> Bool {
        directories[url] != nil
    }

    func fileExists(at url: URL) -> Bool {
        files[url] != nil
    }

    func createDirectoryIfDoesNotExists(at url: URL) throws {
        directories[url] = Directory(
            path: url.absoluteString,
            creationDate: Date()
        )
    }

    func createEmptyFile(at url: URL) throws {
        files[url] = ""
    }

    func contents(at url: URL) -> String? {
        return files[url]
    }

    func write(_ contents: String, at url: URL) throws {
        files[url] = contents
    }

    func directoriesNames(under url: URL) -> [String] {
        return directories.values
            .sorted(by: { $0.creationDate > $1.creationDate })
            .map { String($0.path.split(separator: "/").last ?? "") }
    }
}
