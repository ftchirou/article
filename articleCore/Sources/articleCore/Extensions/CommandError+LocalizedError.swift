//
//  CommandError+LocalizedError.swift
//  
//
//  Created by Faiçal Tchirou on 27/10/2019.
//

import Foundation

extension CommandError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case let .articleNotFound(id):
            return "could not find an article with the id <\(id)> in \(Current.fileManager.blogSourceDirectoryURL.path)"
        case let .duplicateArticle(id):
            return "there is already an article with the id <\(id)> in \(Current.fileManager.blogSourceDirectoryURL.path)"
        case let .couldNotReadArticleMarkdown(id):
            return "could not read the markdown contents of the article with the id <\(id)>"
        case let .error(error):
            return error
        case .noCommandToRun:
            return "there was no command to run"
        }
    }
}
