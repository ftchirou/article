//
//  StandardLogger.swift
//  
//
//  Created by Faiçal Tchirou on 31/10/2019.
//

import Foundation

struct StandardLogger: Logger {
    func logInfo(_ message: String) {
        FileHandle.standardOutput.write(Data("\(message)\n".utf8))
    }

    func logError(_ message: String) {
        FileHandle.standardError.write(Data("\(message)\n".utf8))
    }
}
