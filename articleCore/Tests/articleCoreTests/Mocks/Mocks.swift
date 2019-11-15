//
//  Mocks.swift
//  
//
//  Created by Faiçal Tchirou on 31/10/2019.
//

import Foundation
@testable import articleCore

enum Mocks {
    static var fileManager: Files { FilesMock() }
    static var markdownConverter: MarkdownConverter { MarkdownConverterMock() }
    static var shell: Shell { ShellMock() }
    static var logger: Logger { LoggerMock() }
    static func environment(
        fileManager: Files = Mocks.fileManager,
        markdownConverter: MarkdownConverter = Mocks.markdownConverter,
        shell: Shell = Mocks.shell,
        logger: Logger = Mocks.logger
    ) -> Environment {
        Environment(
            fileManager: fileManager,
            markdownConverter: markdownConverter,
            shell: shell,
            logger: logger
        )
    }
}
