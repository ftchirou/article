//
//  LoggerMock.swift
//  
//
//  Created by Faiçal Tchirou on 31/10/2019.
//

import Foundation
@testable import articleCore

struct LoggerMock: Logger {
    func logInfo(_ message: String) {
    }

    func logError(_ message: String) {
    }
}
