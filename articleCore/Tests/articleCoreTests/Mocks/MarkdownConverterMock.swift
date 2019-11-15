//
//  MarkdownConverterMock.swift
//  
//
//  Created by Faiçal Tchirou on 31/10/2019.
//

import Foundation

@testable import articleCore

class MarkdownConverterMock: MarkdownConverter {
    enum Error: Swift.Error {
        case conversionFailed
    }

    private var htmls: [Markdown: HTML] = [:]

    func `return`(_ html: HTML, for markdown: Markdown) {
        htmls[markdown] = html
    }

    func convertToHTML(_ markdown: Markdown, completion: @escaping (Result<HTML, Swift.Error>) -> Void) {
        if let html = htmls[markdown] {
            return completion(.success(html))
        }

        completion(.failure(Error.conversionFailed))
    }
}
