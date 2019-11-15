//
//  Article.swift
//  
//
//  Created by Faiçal Tchirou on 27/10/2019.
//

import Foundation

enum Article: Equatable {
    case withId(String)
    case inCurrentDirectory
    case none
}

extension Article {
    var id: String {
        switch self {
        case let .withId(id):
            return id
        case .inCurrentDirectory:
            return URL(fileURLWithPath: Current.fileManager.currentDirectoryPath)
                .lastPathComponent
        case .none:
            return ""
        }
    }
}
