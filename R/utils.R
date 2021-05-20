#' @rdname news-utils
#'
#' @aliases pkgHeadings headingsFormat headerCase updateHeading
#'
#' @title Utilities for manipulating NEWS.md headers
#'
#' @description We provide several utilties for working with Markdown-style
#' NEWS.md files. Such operations include the manipulation of NEWS.md file
#' headers and header case.
#'
#' @param packages character() A vector of package names that correspond
#'     to folders in the current directory.
#'
#' @param pkg character(1) The name of a local package whose folder is in
#'     in the current working directory.
#'
#' @param vpattern character(1) The 'grep' input for searching the versioning
#'     line in the NEWS files. This usually starts with 'Changes in version'
#'     (default) but may differ.
#'
#' @param dry.run logical(1) Whether to print changes to the console (TRUE) or
#'     change the actual NEWS file in the package.
#'
#' @param bumpHeaders logical(1) Whether to increase all markdown headers
#'     by one (usually '##' to '###'; default TRUE)
#'
#' @param from character(1) The Markdown header to identify in the NEWS.md file
#'     (default '#' aka HTML tag 'h1')
#'
#' @param to character(1) The Markdown header to replace in the NEWS.md file
#'     (default '##' aka HTML tag 'h2')
#'
#' @section Headings:
#' Obtain the NEWS file Markdown headings ('##') for a list of packages
#' with `pkgHeadings` which calls `headingsFormat` recursively.
#' It is useful to see whether there is consistency in the headings
#' corresponding to the 'Changes in version' line in the NEWS.md file
#'
#' `headerCase` uses the `vpattern` input to replace any differently
#' formatted NEWS.md heading, e.g. `CHANGES IN VERSION` to
#' `Changes in version` where the differences are by case only.
#'
#' `updateHeading` Increases the Markdown HTML h1 tags to h2 tags with the
#' option (`bumpHeaders = TRUE`) to bump all the headers for the remaining
#' sub-headers in order to maintain hierarchy, e.g., h2 to h3.
#'
#' @md
#'
#' @examples
#' \dontrun{
#'     pkgHeadings(
#'         c("MultiAssayExperiment", "curatedTCGAData", "TCGAutils",
#'         "cBioPortalData", "SingleCellMultiModal", "RTCGAToolbox",
#'         "RaggedExperiment")
#'     )
#'
#'     headingsFormat("curatedTCGAData", "Changes in version")
#'
#'     headerCase("RTCGAToolbox")
#'
#'     updateHeading("cBioPortalData")
#' }
#'
pkgHeadings <- function(packages, vpattern = "Changes in version") {
    packages <- setNames(packages, packages)
    lapply(packages, headingsFormat, vpattern = vpattern)
}

#' @export
headingsFormat <- function(pkg, vpattern) {
    if (missing(pkg))
        stop("Provide a valid package name and directory: 'pkg'")
    newsfile <- .findNEWSfile(pkg)
    newslines <- readLines(newsfile)
    headers <- grep(vpattern, newslines, ignore.case = TRUE, value = TRUE)
    unique(vapply(strsplit(headers, "\\s"), `[`, character(1L), 1L))
}

#' @export
headerCase <- function(pkg, vpattern = "Changes in version", dry.run = TRUE) {
    if (missing(pkg))
        stop("Provide a valid package name and directory: 'pkg'")

    newsfile <- .findNEWSfile(pkg)
    newslines <- readLines(newsfile)
    newslines <- gsub(vpattern, vpattern, newslines, ignore.case = TRUE)

    if (dry.run)
        newslines
    else
        writeLines(newslines, con = file(newsfile))
}

#' @export
updateHeading <-
    function(pkg = ".", vpattern = "Changes in version", from = "#", to = "##",
        bumpHeaders = TRUE, dry.run = TRUE)
{
    newsfile <- .findNEWSfile(pkg)
    newslines <- readLines(newsfile)
    if (bumpHeaders) {
        stt <- paste0("^", to)
        newslines <- gsub(stt, paste0(to, from), newslines)
    }
    newslines <- gsub(
        paste0("^", from, "\\s+", vpattern),
        paste0(to, " ", vpattern),
        newslines
    )
    if (dry.run)
        newslines
    else
        writeLines(newslines, con = file(newsfile))
}
