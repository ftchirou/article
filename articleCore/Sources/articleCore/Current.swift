//
//  Current.swift
//  
//
//  Created by Faiçal Tchirou on 13/10/2019.
//

import Foundation

var Current = Environment(
    fileManager: FileManager.default,
    markdownConverter: GithubMarkdownConverter(),
    shell: System(),
    logger: StandardLogger()
)
