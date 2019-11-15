//
//  Command.swift
//  
//
//  Created by Faiçal Tchirou on 14/10/2019.
//

import Foundation

indirect enum Command: Equatable {
    case new(Article)
    case make(Article)
    case makeAll
    case open(Article)
    case openHTML(Article)
    case makeIndex
    case list
    case rename(Article, Article)
    case remove(Article)
    case help(Command)
    case none
}

typealias CommandOutput = String

enum CommandError: Error {
    case articleNotFound(String)
    case duplicateArticle(String)
    case couldNotReadArticleMarkdown(String)
    case error(String)
    case noCommandToRun
}

typealias CommandResult = Result<CommandOutput, CommandError>

extension Command {
    func run(completion: @escaping (CommandResult) -> Void) {
        switch self {
        case let .new(article):
            newArticle(article, completion: completion)
        case let .make(article):
            makeArticle(article, completion: completion)
        case .makeAll:
            makeAllArticles(completion: completion)
        case let .open(article):
            openArticle(article, completion: completion)
        case let .openHTML(article):
            openHTML(article, completion: completion)
        case .makeIndex:
            makeIndex(completion: completion)
        case .list:
            list(completion: completion)
        case let .rename(article, newArticle):
            renameArticle(article, to: newArticle, completion: completion)
        case let .remove(article):
            removeArticle(article, completion: completion)
        case let .help(command):
            completion(.success(command.help))
        case .none:
            completion(.failure(.noCommandToRun))
        }
    }
}

extension Command {
    private func newArticle(_ article: Article, completion: @escaping (CommandResult) -> Void) {
        guard fileManager.directoryExists(at: article.sourceDirectoryURL) == false else {
            return completion(.failure(.duplicateArticle(article.id)))
        }

        do {
            try fileManager.createDirectoryIfDoesNotExists(at: article.sourceDirectoryURL)
            try fileManager.createEmptyFile(at: article.readMeURL)

            completion(.success("new article <\(article.id)> created at \(article.sourceDirectoryURL.path)"))
        } catch {
            completion(.failure(.error(error.localizedDescription)))
        }
    }

    private func makeArticle(_ article: Article, completion: @escaping (CommandResult) -> Void) {
        guard fileManager.fileExists(at: article.readMeURL) else {
            return completion(.failure(.articleNotFound(article.id)))
        }

        guard let markdown = fileManager.contents(at: article.readMeURL) else {
            return completion(.failure(.couldNotReadArticleMarkdown(article.id)))
        }

        markdown.toHtml { result in
            switch result {
            case let .success(content):
                do {
                    try self.fileManager.createDirectoryIfDoesNotExists(at: article.buildDirectoryURL)
                    let html = HTMLTemplates.article(.init(
                        id: article.id,
                        title: markdown.title,
                        markdownAbstract: markdown.abstract,
                        markdownContent: markdown,
                        htmlAbstract: "",
                        htmlContent: content,
                        commit: article.firstCommit,
                        creationDate: article.creationDate
                    ))
                    try self.fileManager.write(html, at: article.HTMLURL)

                    completion(.success("HTML successfully generated at \(article.HTMLURL.path)"))
                } catch {
                    completion(.failure(.error(error.localizedDescription)))
                }
            case let .failure(error):
                completion(.failure(.error(error.localizedDescription)))
            }
        }
    }

    private func makeAllArticles(completion: @escaping (CommandResult) -> Void) {
        makeArticles(allArticles(), completion: completion)
    }

    private func makeArticles(_ articles: [Article], completion: @escaping (CommandResult) -> Void) {
        guard articles.isEmpty == false else {
            return completion(.success("done!"))
        }

        var articles = articles
        let article = articles.removeFirst()

        makeArticle(article) { result in
            switch result {
            case let .success(output):
                Current.logger.logInfo(output)
            case let .failure(error):
                Current.logger.logError(error.localizedDescription)
            }

            self.makeArticles(articles, completion: completion)
        }
    }

    private func openArticle(_ article: Article, completion: @escaping (CommandResult) -> Void) {
        guard fileManager.fileExists(at: article.readMeURL) else {
            return completion(.failure(.articleNotFound(article.id)))
        }

        Current.shell.run(.open(article.readMeURL.path))
        completion(.success("\(article.readMeURL.path) opened"))
    }

    private func openHTML(_ article: Article, completion: @escaping (CommandResult) -> Void) {
        guard fileManager.fileExists(at: article.HTMLURL) else {
            return completion(.failure(.articleNotFound(article.id)))
        }

        Current.shell.run(.open(article.HTMLURL.path))
        completion(.success("\(article.HTMLURL.path) opened"))
    }

    private func makeIndex(completion: @escaping (CommandResult) -> Void) {
        buildHTMLListItems(for: allArticles(), items: []) { items in
            let index = HTMLTemplates.home(articles: items)

            do {
                try self.fileManager.createDirectoryIfDoesNotExists(at: self.fileManager.blogBuildDirectoryURL)
                try self.fileManager.write(index, at: self.fileManager.blogIndexURL)
                completion(.success("index successfully built at \(self.fileManager.blogIndexURL.path)"))
            } catch {
                completion(.failure(.error(error.localizedDescription)))
            }
        }
    }

    private func list(completion: @escaping (CommandResult) -> Void) {
        completion(.success(allArticles()
            .filter { fileManager.fileExists(at: $0.readMeURL) }
            .map { $0.id }
            .joined(separator: "\n")
        ))
    }

    private func renameArticle(_ article: Article, to newArticle: Article, completion: @escaping (CommandResult) -> Void) {
        guard fileManager.fileExists(at: article.readMeURL) else {
            return completion(.failure(.articleNotFound(article.id)))
        }

        guard fileManager.fileExists(at: newArticle.readMeURL) == false else {
            return completion(.failure(.duplicateArticle(newArticle.id)))
        }

        Current.shell.run(.moveDirectory(article.sourceDirectoryURL.path, newArticle.sourceDirectoryURL.path))
        completion(.success("<\(article.id)> successfully renamed to <\(newArticle.id)>"))
    }

    private func removeArticle(_ article: Article, completion: @escaping (CommandResult) -> Void) {
        guard fileManager.directoryExists(at: article.sourceDirectoryURL)
            && fileManager.fileExists(at: article.readMeURL) else {
            return completion(.failure(.articleNotFound(article.id)))
        }

        do {
            let path = article.sourceDirectoryURL.path

            if let trash = fileManager.blogTrashDirectoryURL {
                try fileManager.createDirectoryIfDoesNotExists(at: trash)
                Current.shell.run(.moveDirectory(path, trash.path))
            } else {
                Current.shell.run(.removeDirectory(path))
            }

            completion(.success("<\(article.id)> successfully removed"))
        } catch {
            completion(.failure(.error(error.localizedDescription)))
        }
    }

    private func buildHTMLListItems(for articles: [Article], items: [ArticleMetadata], completion: @escaping ([ArticleMetadata]) -> Void) {
        var articles = articles

        guard let article = articles.first else {
            completion(items)
            return
        }

        buildHTMLListItem(for: article) { item in
            articles.removeFirst(1)
            self.buildHTMLListItems(for: articles, items: items + [item], completion: completion)
        }
    }

    private func buildHTMLListItem(for article: Article, completion: @escaping (ArticleMetadata) -> Void) {
        guard fileManager.fileExists(at: article.readMeURL) == true else {
            completion(.empty)
            return
        }

        guard let markdown = fileManager.contents(at: article.readMeURL) else {
            completion(.empty)
            return
        }

        markdown.abstract.toHtml { result in
            switch result {
            case let .success(html):
                completion(.init(
                    id: article.id,
                    title: markdown.title,
                    markdownAbstract: markdown.abstract,
                    markdownContent: markdown,
                    htmlAbstract: html,
                    htmlContent: "",
                    commit: article.firstCommit,
                    creationDate: article.creationDate
                ))
            case .failure:
                completion(.empty)
            }
        }
    }

    private func allArticles() -> [Article] {
        return fileManager
            .directoriesNames(under: fileManager.blogSourceDirectoryURL)
            .map { Article.withId($0) }
            .sorted(by: { $0.creationDate ?? Date.distantFuture > $1.creationDate ?? Date.distantFuture })
    }

    private var fileManager: Files {
        Current.fileManager
    }
}
