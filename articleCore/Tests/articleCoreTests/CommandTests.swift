//
//  CommandTests.swift
//  
//
//  Created by Faiçal Tchirou on 31/10/2019.
//

import XCTest
@testable import articleCore

private let waitTime: TimeInterval = 1.0

class CommandTests: XCTestCase {
    override func setUp() {
        super.setUp()
        Current = Mocks.environment()
    }

    func testNewCommand() {
        let expectation = self.expectation(description: "the new command should create directories and files for the new article")
        let article: Article = .withId("hello-world")
        let command: Command = .new(article)

        command.run { result in
            switch result {
            case .success:
                XCTAssertTrue(Current.fileManager.directoryExists(at: article.sourceDirectoryURL))
                XCTAssertTrue(Current.fileManager.fileExists(at: article.readMeURL))
                XCTAssertTrue(Current.fileManager.contents(at: article.readMeURL)?.isEmpty ?? false)
            case let .failure(error):
                XCTFail(error.localizedDescription)
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: waitTime)
    }

    func testMakeCommand() throws {
        let expectation = self.expectation(description: "the make command should create HTML files in the article's build directory")
        let article: Article = .withId("hello-world")
        let markdown = "# Hello, World!"
        let html = "<h1>Hello, World!</h1>"
        let command: Command = .make(article)

        try Current.fileManager.write(markdown, at: article.readMeURL)
        Current.testMarkdownConverter.return(html, for: markdown)

        command.run { result in
            switch result {
            case .success:
                XCTAssertTrue(Current.fileManager.fileExists(at: article.HTMLURL))
                XCTAssertEqual(
                    Current.fileManager.contents(at: article.HTMLURL),
                    HTMLTemplates.article(.init(
                        id: article.id,
                        title: "Hello, World!",
                        markdownAbstract: "",
                        markdownContent: markdown,
                        htmlAbstract: "",
                        htmlContent: html,
                        commit: nil,
                        creationDate: nil
                    ))
                )
            case let .failure(error):
                XCTFail(error.localizedDescription)
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: waitTime)
    }

    func testMakeAllCommand() throws {
        let expectation = self.expectation(description: "the make-all command should make all the articles available in $BLOG_SRC")
        let articles: [Article] = [.withId("article-1"), .withId("article-2"), .withId("article-3")]

        for article in articles {
            ensureArticleExists(article)
        }

        Command.makeAll.run { result in
            switch result {
            case .success:
                for article in articles {
                    XCTAssertTrue(Current.fileManager.fileExists(at: article.HTMLURL))
                }
            case let .failure(error):
                XCTFail(error.localizedDescription)
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: waitTime)
    }

    func testOpenCommand() throws {
        let expectation = self.expectation(description: "the open command should open the article's README file")
        let article: Article = .withId("hello-world")
        let command: Command = .open(article)

        ensureArticleExists(article)

        command.run { result in
            switch result {
            case .success:
                XCTAssertTrue(Current.testShell.didOpen(article.readMeURL.path))
            case let .failure(error):
                XCTFail(error.localizedDescription)
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: waitTime)
    }

    func testOpenHTMLCommand() {
        let expectation = self.expectation(description: "the open-html command should open the article's HTML file")
        let article: Article = .withId("hello-world")
        let command: Command = .openHTML(article)

        ensureArticleIsBuilt(article)

        command.run { result in
            switch result {
            case .success:
                XCTAssertTrue(Current.testShell.didOpen(article.HTMLURL.path))
            case let .failure(error):
                XCTFail(error.localizedDescription)
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: waitTime)
    }

    func testMakeIndexCommand() throws {
        let expectation = self.expectation(description: "the make-index command should create a new and updated index.html")
        let article: Article = .withId("hello-world")
        let command: Command = .makeIndex

        Command.new(article).run { result in
            switch result {
            case .success:
                let markdown = "# Hello, World!\nHello, World!"
                let html = "<p>Hello, World!</p>"

                try? Current.fileManager.write(markdown, at: article.readMeURL)
                Current.testMarkdownConverter.return(html, for: markdown.abstract)

                command.run { result in
                    switch result {
                    case .success:
                        XCTAssertTrue(Current.fileManager.fileExists(at: Current.fileManager.blogIndexURL))
                        XCTAssertEqual(
                            Current.fileManager.contents(at: Current.fileManager.blogIndexURL),
                            HTMLTemplates.home(articles: [.init(
                                id: article.id,
                                title: "Hello, World!",
                                markdownAbstract: "",
                                markdownContent: "",
                                htmlAbstract: html,
                                htmlContent: "",
                                commit: nil,
                                creationDate: nil
                            )])
                        )
                    case let .failure(error):
                        XCTFail(error.localizedDescription)
                    }

                    expectation.fulfill()
                }
            case let .failure(error):
                XCTFail(error.localizedDescription)
            }
        }

        wait(for: [expectation], timeout: waitTime)
    }

    func testListCommand() {
        let expectation = self.expectation(description: "the list command should list all articles in the blog source directory")
        let command: Command = .list

        ensureArticleExists(.withId("article-1"))
        ensureArticleExists(.withId("article-2"))
        ensureArticleExists(.withId("article-3"))
        ensureArticleExists(.withId("article-4"))
        ensureArticleExists(.withId("article-5"))

        command.run { result in
            switch result {
            case let .success(output):
                XCTAssertEqual(output, """
                article-5
                article-4
                article-3
                article-2
                article-1
                """)
            case let .failure(error):
                XCTFail(error.localizedDescription)
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: waitTime)
    }

    func testRenameCommand() throws {
        let expectation = self.expectation(description: "the rename command should rename the first article's source directory to the new id provided")
        let article: Article = .withId("hello-world")
        let newArticle: Article = .withId("hello-world-2")

        ensureArticleExists(article)

        try Current.fileManager.write("# Hello, World!", at: article.readMeURL)

        let command: Command = .rename(article, newArticle)

        command.run { result in
            switch result {
            case .success:
                XCTAssertTrue(Current.testShell.didMove(article.sourceDirectoryURL.path, newArticle.sourceDirectoryURL.path))
            case let .failure(error):
                XCTFail(error.localizedDescription)
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: waitTime)
    }

    func testRemoveCommand() {
        let expectation = self.expectation(description: "the remove command should remove the specified article")
        let article: Article = .withId("hello-world")
        let command: Command = .remove(article)

        ensureArticleExists(article)

        command.run { result in
            switch result {
            case .success:
                XCTAssertTrue(Current.testShell.didMove(article.sourceDirectoryURL.path, Current.fileManager.blogTrashDirectoryURL?.path ?? ""))
            case let .failure(error):
                XCTFail(error.localizedDescription)
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: waitTime)
    }
}

extension CommandTests {
    static var allTests = [
        ("testNewCommand\\", testNewCommand),
        ("testMakeCommand\\", testMakeCommand),
        ("testMakeAllCommand\\", testMakeAllCommand),
        ("testOpenCommand\\", testMakeCommand),
        ("testOpenHTMLCommand\\", testOpenHTMLCommand),
        ("testListCommand\\", testListCommand),
        ("testRenameCommand\\", testRenameCommand),
        ("testRemoveCommand\\", testRemoveCommand),
    ]
}

extension Environment {
    fileprivate var testMarkdownConverter: MarkdownConverterMock {
        return markdownConverter as! MarkdownConverterMock
    }

    fileprivate var testShell: ShellMock {
        return shell as! ShellMock
    }
}

extension CommandTests {
    private func ensureArticleExists(_ article: Article) {
        let expectation = self.expectation(description: "the specified article should exist")

        Command.new(article).run { result in
            switch result {
            case .success:
                let markdown = "# \(article.id)"
                try? Current.fileManager.write(markdown, at: article.readMeURL)
                Current.testMarkdownConverter.return("<p>\(article.id)</p>", for: markdown)
            case let .failure(error):
                XCTFail(error.localizedDescription)
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: waitTime)
    }

    private func ensureArticleIsBuilt(_ article: Article) {
        ensureArticleExists(article)

        let expectation = self.expectation(description: "the specified article build files should exist")

        Command.make(article).run { result in
            switch result {
            case let .failure(error):
                XCTFail(error.localizedDescription)
            default:
                break
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: waitTime)
    }
}
