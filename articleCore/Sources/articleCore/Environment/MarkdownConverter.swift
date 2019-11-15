//
//  MarkdownConverter.swift
//  
//
//  Created by Faiçal Tchirou on 29/10/2019.
//

import Foundation

protocol MarkdownConverter {
    func convertToHTML(_ markdown: Markdown, completion: @escaping (Result<HTML, Error>) -> Void)
}
