//
//  FileManager+Files.swift
//  
//
//  Created by Faiçal Tchirou on 27/10/2019.
//

import Foundation

extension FileManager: Files {
    var blogSourceDirectoryURL: URL {
        guard let path = ProcessInfo.processInfo.environment["BLOG_SRC"] else {
            return homeDirectoryForCurrentUser
        }

        return URL(fileURLWithPath: path, isDirectory: true)
    }

    var blogBuildDirectoryURL: URL {
        guard let path = ProcessInfo.processInfo.environment["BLOG_BUILD"] else {
            return homeDirectoryForCurrentUser
        }

        return URL(fileURLWithPath: path, isDirectory: true)
    }

    var blogTrashDirectoryURL: URL? {
        guard let path = ProcessInfo.processInfo.environment["BLOG_TRASH"] else {
            return nil
        }

        return URL(fileURLWithPath: path, isDirectory: true)
    }

    var blogIndexURL: URL {
        URL(fileURLWithPath: "index.html", relativeTo: blogBuildDirectoryURL)
    }

    func directoryExists(at url: URL) -> Bool {
        var isDirectory: ObjCBool = false
        let fileExists = self.fileExists(atPath: url.path, isDirectory: &isDirectory)
        return fileExists && isDirectory.boolValue
    }

    func fileExists(at url: URL) -> Bool {
        var isDirectory: ObjCBool = false
        let fileExists = self.fileExists(atPath: url.path, isDirectory: &isDirectory)
        return fileExists && isDirectory.boolValue == false
    }

    func createDirectoryIfDoesNotExists(at url: URL) throws {
        if directoryExists(at: url) == false {
            try createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
    }

    func createEmptyFile(at url: URL) throws {
        try "".write(to: url, atomically: true, encoding: .utf8)
    }

    func contents(at url: URL) -> String? {
        if let data = contents(atPath: url.path) {
            return String(data: data, encoding: .utf8)
        }

        return nil
    }

    func write(_ contents: String, at url: URL) throws {
        try contents.write(to: url, atomically: true, encoding: .utf8)
    }

    func directoriesNames(under url: URL) -> [String] {
        do {
            let urls = try contentsOfDirectory(
                at: url,
                includingPropertiesForKeys: [.isDirectoryKey],
                options: [.skipsSubdirectoryDescendants, .skipsHiddenFiles]
            )

            return urls.map { $0.lastPathComponent }
        } catch {
            return []
        }
    }
}
