//
//  GithubMarkdownConverter.swift
//  
//
//  Created by Faiçal Tchirou on 29/10/2019.
//

import Foundation

struct GithubMarkdownConverter: MarkdownConverter {
    enum Error: Swift.Error {
        case conversionFailed
        case error(String)
    }

    func convertToHTML(_ markdown: Markdown, completion: @escaping (Result<HTML, Swift.Error>) -> Void) {
        var request = URLRequest(url: URL(string: "https://api.github.com/markdown")!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(
            withJSONObject: ["text": markdown, "mode": "markdown"],
            options: .fragmentsAllowed
        )

        if let githubToken = ProcessInfo.processInfo.environment["GITHUB_TOKEN"] {
            request.addValue("token \(githubToken)", forHTTPHeaderField: "Authorization")
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(Error.conversionFailed))
                return
            }

            if let data = data, let html = String(data: data, encoding: .utf8) {
                completion(.success(html))
                return
            }

            if let error = error {
                completion(.failure(Error.error(error.localizedDescription)))
                return
            }

            completion(.failure(Error.conversionFailed))
        }.resume()
    }
}

extension GithubMarkdownConverter.Error: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .conversionFailed:
            return "the conversion to HTML failed. Please try again."
        case let .error(error):
            return error
        }
    }
}
