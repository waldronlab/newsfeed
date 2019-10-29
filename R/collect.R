.findNEWSfile <- function(pkg) {
    pkgLoc <- system.file(package = pkg)
    newsfile <- list.files(pkgLoc, pattern = "^NEWS", recursive = TRUE,
        full.names = TRUE)
    if (length(newsfile) > 1)
            stop("Multiple NEWS files found in package folder")
    newsfile
}

.checkPkgName <- function(pkg, newstext) {
    in_first_line <- grepl(pkg, newstext[1])
    if (in_first_line)
        stop("The NEWS* file should not contain the package name;",
            "\n Test package with 'utils::news'")
}

#' Compile NEWS files from several packages
#'
#' This package will take the first chunk of a NEWS file and
#' return it as a character vector
#'
#' @param packages A character vector of packages installed on the system
#'
#' @param vpattern The 'grep' input for searching the versioning line in the
#'     NEWS files. This usually starts with 'Changes in version' but may differ.
#'
#' @param render logical(1) Whether to produce an HTML document for viewing
#'     (default FALSE)
#'
#' @examples
#'
#' collect("newsfeed")
#'
#' @export
collect <-
    function(packages, vpattern = "Changes in version", render = FALSE)
{
    packages <- setNames(packages, packages)
    listNEWS <- lapply(packages, function(pkg) {
        nloc <- .findNEWSfile(pkg)
        newstext <- readLines(nloc)
        .checkPkgName(pkg, newstext)
        c(pkg, paste0(rep("-", 64), collapse = ""), "", newstext, "")
    })

    indx <- lapply(listNEWS, function(pkgLines) {
        vers <-
            head(
                grep(vpattern, ignore.case = TRUE, pkgLines),
            2L)
        if (identical(length(vers), 1L))
            length(pkgLines)
        else
            vers[[2L]] - 1L
    })

    newsfeed <-  unname(unlist(
        Map(function(x, y) x[seq_len(y)], x = listNEWS, y = indx)
    ))

    if (render) {
        mdfile <- tempfile(fileext = ".md")
        writeLines(text = newsfeed, con = mdfile)
        if (!requireNamespace("rmarkdown", quietly = TRUE))
            stop("Install 'rmarkdown' to use 'render=TRUE'")
        htmlfile <- rmarkdown::render(mdfile, quiet = TRUE, encoding = "UTF-8")
        browseURL(htmlfile)
    }

    if (!requireNamespace("clipr", quietly = TRUE) || !clipr::clipr_available())
        newsfeed
    else
        clipr::write_clip(newsfeed)
}
