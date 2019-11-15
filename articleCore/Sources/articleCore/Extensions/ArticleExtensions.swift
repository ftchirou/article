//
//  ArticleExtensions.swift
//  
//
//  Created by Faiçal Tchirou on 27/10/2019.
//

import Foundation

extension Article {
    var sourceDirectoryURL: URL {
        switch self {
        case let .withId(id):
            return URL(fileURLWithPath: id, relativeTo: Current.fileManager.blogSourceDirectoryURL)
        case .inCurrentDirectory:
            return URL(fileURLWithPath: Current.fileManager.currentDirectoryPath)
        case .none:
            return URL(fileURLWithPath: "none")
        }
    }

    var buildDirectoryURL: URL {
        URL(fileURLWithPath: "articles", relativeTo: Current.fileManager.blogBuildDirectoryURL)
    }

    var readMeURL: URL {
        URL(fileURLWithPath: "README.md", relativeTo: sourceDirectoryURL)
    }

    var HTMLURL: URL {
        URL(fileURLWithPath: "\(id).html", relativeTo: buildDirectoryURL)
    }

    var firstCommit: String? {
        let result = Current.shell.run(.getFirstCommit(Current.fileManager.blogSourceDirectoryURL, readMeURL.path))

        return result.status == .success
            ? result.output
            : nil
    }

    var creationDate: Date? {
        guard let commit = firstCommit else {
            return nil
        }

        let commitDateResult = Current.shell.run(.getCommitDate(Current.fileManager.blogSourceDirectoryURL, commit))

        guard commitDateResult.status == .success else {
            return nil
        }

        let isoFormattedDate = commitDateResult.output.trimmingCharacters(in: .init(charactersIn: "'"))
        let dateFormatter = ISO8601DateFormatter()
        return dateFormatter.date(from: isoFormattedDate)
    }
}
