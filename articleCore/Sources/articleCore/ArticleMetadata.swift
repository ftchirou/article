//
//  ArticleMetadata.swift
//  
//
//  Created by Faiçal Tchirou on 31/10/2019.
//

import Foundation

struct ArticleMetadata {
    let id: String
    let title: String
    let markdownAbstract: String
    let markdownContent: String
    let htmlAbstract: String
    let htmlContent: String
    let commit: GitCommit?
    let creationDate: Date?
}

extension ArticleMetadata {
    static var empty: ArticleMetadata {
        .init(
            id: "",
            title: "",
            markdownAbstract: "",
            markdownContent: "",
            htmlAbstract: "",
            htmlContent: "",
            commit: nil,
            creationDate: nil
        )
    }
}
