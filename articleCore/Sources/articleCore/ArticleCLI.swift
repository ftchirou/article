//
//  ArticleCLI.swift
//  
//
//  Created by Faiçal Tchirou on 31/10/2019.
//

import Foundation

public enum ArticleCLI {
    public static func run(with arguments: [String], completion: @escaping (Result<String, Error>) -> Void) {
        do {
            let parser = CommandParser(arguments: CommandLine.arguments)
            let command = try parser.parse()
            command.run { result in
                switch result {
                case let .success(output): completion(.success(output))
                case let .failure(error): completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
}
