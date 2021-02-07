//
//  HTMLTemplates.swift
//  
//
//  Created by Faiçal Tchirou on 27/10/2019.
//

import Foundation

enum HTMLTemplates {
    static func article(_ metadata: ArticleMetadata) -> String {
        return """
        <!DOCTYPE html><html><head><meta charset="utf-8"><link rel="shortcut icon" href="/favicon.ico"><link rel="icon" sizes="16x16 32x32 64x64" href="/favicon.ico"><link rel="icon" type="image/png" sizes="196x196" href="/favicon-192.png"><link rel="icon" type="image/png" sizes="160x160" href="/favicon-160.png"><link rel="icon" type="image/png" sizes="96x96" href="/favicon-96.png"><link rel="icon" type="image/png" sizes="64x64" href="/favicon-64.png"><link rel="icon" type="image/png" sizes="32x32" href="/favicon-32.png"><link rel="icon" type="image/png" sizes="16x16" href="/favicon-16.png"><link rel="apple-touch-icon" href="/favicon-57.png"><link rel="apple-touch-icon" sizes="114x114" href="/favicon-114.png"><link rel="apple-touch-icon" sizes="72x72" href="/favicon-72.png"><link rel="apple-touch-icon" sizes="144x144" href="/favicon-144.png"><link rel="apple-touch-icon" sizes="60x60" href="/favicon-60.png"><link rel="apple-touch-icon" sizes="120x120" href="/favicon-120.png"><link rel="apple-touch-icon" sizes="76x76" href="/favicon-76.png"><link rel="apple-touch-icon" sizes="152x152" href="/favicon-152.png"><link rel="apple-touch-icon" sizes="180x180" href="/favicon-180.png"><meta name="msapplication-TileColor" content="#FFFFFF"><meta name="msapplication-TileImage" content="/favicon-144.png"><meta name="msapplication-config" content="/browserconfig.xml"><link rel="stylesheet" href="../styles/fonts.css"><link rel="stylesheet" href="../styles/main.css"><link rel="stylesheet" href="../styles/swift.css"><link rel="stylesheet" href="../styles/shell.css"><meta name="viewport", content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=0"><meta property="og:type" content="website"><meta property="og:url" content="https://faical.dev/articles/\(metadata.id).html"><meta property="og:title" content="\(metadata.title)"><meta property="og:description" content="\(metadata.markdownAbstract)"><meta property="og:image" content="https://faical.dev/assets/cards/\(metadata.id).png"><meta name="twitter:card" content="summary_large_image"><meta name="twitter:domain" value="faical.dev"><meta name="twitter:title" value="\(metadata.title)"><meta name="twitter:description" value="\(metadata.markdownAbstract)">\(creationDateMetaTag(metadata))<meta name="twitter:image" content="https://faical.dev/assets/cards/\(metadata.id).png"><title>\(metadata.title)</title></head><body><div class="container">\(metadata.htmlContent)<br><hr noshade><div class="footer"><span class="cta"><a href="/">Back to all articles</a></span>\(creationDateLinkTag(metadata))</div></div></body></html>
        """
    }

    static func home(articles: [ArticleMetadata]) -> String {
        return """
        <!DOCTYPE html><html><head><meta charset="utf-8"><link rel="shortcut icon" href="/favicon.ico"><link rel="icon" sizes="16x16 32x32 64x64" href="/favicon.ico"><link rel="icon" type="image/png" sizes="196x196" href="/favicon-192.png"><link rel="icon" type="image/png" sizes="160x160" href="/favicon-160.png"><link rel="icon" type="image/png" sizes="96x96" href="/favicon-96.png"><link rel="icon" type="image/png" sizes="64x64" href="/favicon-64.png"><link rel="icon" type="image/png" sizes="32x32" href="/favicon-32.png"><link rel="icon" type="image/png" sizes="16x16" href="/favicon-16.png"><link rel="apple-touch-icon" href="/favicon-57.png"><link rel="apple-touch-icon" sizes="114x114" href="/favicon-114.png"><link rel="apple-touch-icon" sizes="72x72" href="/favicon-72.png"><link rel="apple-touch-icon" sizes="144x144" href="/favicon-144.png"><link rel="apple-touch-icon" sizes="60x60" href="/favicon-60.png"><link rel="apple-touch-icon" sizes="120x120" href="/favicon-120.png"><link rel="apple-touch-icon" sizes="76x76" href="/favicon-76.png"><link rel="apple-touch-icon" sizes="152x152" href="/favicon-152.png"><link rel="apple-touch-icon" sizes="180x180" href="/favicon-180.png"><meta name="msapplication-TileColor" content="#FFFFFF"><meta name="msapplication-TileImage" content="/favicon-144.png"><meta name="msapplication-config" content="/browserconfig.xml"><link rel="stylesheet" href="styles/fonts.css"><link rel="stylesheet" href="styles/main.css"><link rel="stylesheet" href="styles/swift.css"><link rel="stylesheet" href="styles/shell.css"><meta name="viewport", content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=0"><meta property="og:url" content="https://faical.dev"><meta property="og:title" content="Faiçal's Personal Blog"><meta property="og:description" content="Articles about Swift, software engineering, books, life, the universe and everything." /><meta name="twitter:card" content="summary"><meta name="twitter:domain" value="faical.dev"><meta name="twitter:title" value="Faiçal's Personal Blog"><meta name="twitter:description" value="Articles about Swift, software engineering, books, life, the universe and everything."><title>Faiçal's Personal Blog</title></head><body><div class="intro"><img class="profile-pic" src="assets/me.png"><div class="bio"><p>Hi 👋! My name is <a href="https://twitter.com/ftchirou">Faiçal Tchirou</a>. I'm a software engineer currently living in Stockholm 🇸🇪. I <a href="https://github.com/ftchirou">write code</a> mostly in <a href="https://docs.swift.org/swift-book/">Swift</a> on and for Apple platforms. This is <a href="https://github.com/ftchirou/faical.dev">my little corner of the Internet</a> where I will be writing about Swift, software engineering, books I read, and anything I happen to be learning or be obsessed about at the moment.</p></div></div>\(latestArticlesDivTag(articles))</body></html>
        """
    }

    private static func latestArticlesDivTag(_ articles: [ArticleMetadata]) -> String {
        guard articles.isEmpty == false else {
            return ""
        }

        return """
        <div class="articles"><h2>Articles</h2><div class="articles-list">\(articles.map { articleDivTag($0) }.joined(separator: "\n"))</div></div>
        """
    }

    private static func articleDivTag(_ metadata: ArticleMetadata) -> String {
        return """
        <div class="article"><h3 class="article-title"><a href="articles/\(metadata.id).html">\(metadata.title)</a></h3>\(creationDateSpanTag(metadata))\(metadata.htmlAbstract)</div>
        """
    }

    private static func creationDateLinkTag(_ metadata: ArticleMetadata) -> String {
        guard let commit = metadata.commit, let creationDate = metadata.creationDate else {
            return ""
        }

        return "<a href=\(commit.link)>\(creationDate.humanReadable)</a>"
    }

    private static func creationDateSpanTag(_ metadata: ArticleMetadata) -> String {
        guard let creationDate = metadata.creationDate else {
            return ""
        }

        return "<span class=\"date\">\(creationDate.humanReadable)</span>"
    }

    private static func creationDateMetaTag(_ metadata: ArticleMetadata) -> String {
        guard let creationDate = metadata.creationDate else {
            return ""
        }

        return "<meta name=\"twitter:label1\" value=\"Published on\"><meta name=\"twitter:data1\" value=\"\(creationDate.humanReadable)\">"
    }

    private static func socialMediaSharingLinkTags(_ metadata: ArticleMetadata) -> String {
        guard
            let percentEncodedUrl = "https://faical.dev/articles/\(metadata.id).html".addingPercentEncoding(withAllowedCharacters: .alphanumerics),
            let percentEncodedTitle = metadata.title.addingPercentEncoding(withAllowedCharacters: .alphanumerics)
        else {
            return ""
        }

        return """
        <p>If you found this article useful, please consider <a href="https://twitter.com/intent/tweet
        ?url=\(percentEncodedUrl)&text=\(percentEncodedTitle)&via=ftchirou" rel="noopener" target="_blank">sharing it on Twitter</a> with your network 🙂.</p>
        """
    }
}

extension Date {
   fileprivate var humanReadable: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, YYYY"
        return formatter.string(from: self)
    }
}

extension GitCommit {
    fileprivate var link: String {
        return "https://github.com/ftchirou/faical.dev/commit/\(self)"
    }
}
