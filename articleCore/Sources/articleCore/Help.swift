//
//  Help.swift
//  
//
//  Created by Faiçal Tchirou on 27/10/2019.
//

import Foundation

extension Command {
    var help: String {
        switch self {
        case .new:
            return """
            usage:
                article new <article-id>
                    Creates a new article with the specified id in $BLOG_SRC.
            """
        case .make:
            return """
            usage:
                article make
                    Generates the static HTML pages of the article in the current directory in $BLOG_BUILD.

                article make <article-id>
                    Generates the static HTML pages of the specified article in $BLOG_BUILD.
            """
        case .makeAll:
            return """
            usage:
                article make-all
                    Generates the static HTML pages for all the articles in $BLOG_SRC and saves them in $BLOG_BUILD.
            """
        case .open:
            return """
            usage:
                article open
                    Opens the source file of the article in the current directory in the user's default Markdown editor.

                article open <article-id>
                    Opens the source file of the specified article in the user's default Markdown editor.
            """
        case .openHTML:
            return """
            usage:
                article open-html
                    Opens the generated HTML of the article in the current directory in the user's default web browser.

                article open-html <article-id>
                    Opens the generated HTML of the specified article in the user's default web browser.
            """
        case .makeIndex:
            return """
            usage:
                article make-index
                    Recreates the homepage of the blog (in $BLOG_BUILD/index.html) with new articles added to the `Latest Articles` section.
            """
        case .list:
            return """
            usage:
                article list
                    Lists all the articles in $BLOG_SRC.
            """
        case .rename:
            return """
            usage:
                article rename <article-id> <new-article-id>
                    Changes the ID of the specified article to <new-article-id>.
            """
        case .remove:
            return """
            article remove <article-id>
                Moves the specified article to $BLOG_TRASH. If $BLOG_TRASH is not set, the specified article is removed from the filesystem.
            """
        case let .help(command):
            return command.help
        case .none:
            return """
            usage:
                article new <article-id>
                    Creates a new article with the specified id in $BLOG_HOME.

                article make
                    Generates the static HTML pages of the article in the current directory in $BLOG_BUILD.

                article make <article-id>
                    Generates the static HTML pages of the specified article in $BLOG_BUILD.

                article make-all
                    Generates the static HTML pages for all the articles in $BLOG_SRC and saves them in $BLOG_BUILD.

                article open
                    Opens the source file of the article in the current directory in the user's default Markdown editor.

                article open <article-id>
                    Opens the source file of the specified article in the user's default Markdown editor.

                article open-html
                    Opens the generated HTML of the article in the current directory in the user's default web browser.

                article open-html <article-id>
                    Opens the generated HTML of the specified article in the user's default web browser.

                article make-index
                    Recreates the homepage of the blog (in $BLOG_BUILD/index.html) with new articles added to the `Latest Articles` section.

                article list
                    Lists all the articles in $BLOG_SRC.

                article rename <article-id> <new-article-id>
                    Changes the ID of the specified article to <new-article-id>.

                article remove <article-id>
                    Moves the specified article to $BLOG_TRASH. If $BLOG_TRASH is not set, the specified article is removed from the filesystem.
            """
        }
    }
}
