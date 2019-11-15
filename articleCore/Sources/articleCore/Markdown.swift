//
//  Markdown.swift
//  
//
//  Created by Faiçal Tchirou on 27/10/2019.
//

import Foundation

typealias Markdown = String

extension Markdown {
    func toHtml(completion: @escaping (Result<HTML, Error>) -> Void) {
        Current.markdownConverter.convertToHTML(self, completion: completion)
    }

    var title: String {
        guard var title =  split(separator: "\n").first else {
            return ""
        }

        title.removeFirst(2)
        return String(title)
    }

    var abstract: String {
        let components = split(separator: "\n")

        guard components.count >= 2 else {
            return ""
        }

        return String(components[1])
            .split(separator: " ")
            .prefix(70)
            .joined(separator: " ") + "..."
    }
}
