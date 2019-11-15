# 🤖 article

`article` is a small command line tool I wrote in Swift to assist me in writing articles for my blog at [https://faical.dev](https://faical.dev).

## Supported commands

```
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
```

