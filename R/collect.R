.NEWS_LOCS <- c("inst/NEWS", "NEWS.md", "inst/NEWS.Rd", "NEWS", "inst/NEWS.md")

utils::globalVariables(.NEWS_LOCS)

.findNEWSfile <- function(pkg) {
    dpkg <- devtools::as.package(pkg)
    npaths <- file.path(dpkg[["path"]], .NEWS_LOCS)
    newlo <- file.exists(npaths)
    if (sum(newlo) > 1)
            stop("Multiple NEWS files found in package folder")
    npaths[newlo]
}

.checkPkgInNews <- function(pkg, newstext) {
    in_first_line <- grepl(pkg, newstext[1])
    if (in_first_line)
        stop("Package name in the NEWS* file not yet supported: ", pkg,
            "\n Use 'renameHeadings' to standardize")
}

.replaceAt <- function(newstext) {
    gsub("@", "\\@", newstext, fixed = TRUE)
}

#' Compile NEWS files from several packages
#'
#' This package will take the first chunk of a NEWS file and
#' return it as a character vector. Users should call this function within
#' a folder *above* all of the packages in the 'packages' argument. This will
#' ensure that the proper NEWS path is obtained.
#'
#' @details The NEWS file location can be in one of four locations relative
#'    to the package directory:
#'     \itemize{
#'          \item{"NEWS.md"}
#'          \item{"NEWS"}
#'          \item{"inst/NEWS"}
#'          \item{"inst/NEWS.md"}
#'          \item{"inst/NEWS.Rd"}
#'     }
#'    Obtained from Bioconductor NEWS guidelines:
#'    \url{https://www.bioconductor.org/developers/package-guidelines/#news}
#'
#' @param packages character() A vector of packages with NEWS files
#'
#' @param vpattern character(1) The 'grep' input for searching the versioning
#'     line in the NEWS files. This usually starts with 'Changes in version'
#'     but may differ.
#'
#' @param render logical(1) Whether to produce an HTML document for viewing
#'     (default: TRUE)
#'
#' @param rawHTML logical(1) Whether to return the raw HTML text when
#'     `render = TRUE` (default: FALSE)
#'
#' @examples
#'
#' collect("newsfeed")
#' \dontrun{
#'     collect(
#'         c("MultiAssayExperiment", "curatedTCGAData", "TCGAutils",
#'         "cBioPortalData", "SingleCellMultiModal", "HCAMatrixBrowser",
#'         "RTCGAToolbox", "RaggedExperiment")
#'     )
#' }
#' @export
collect <-
    function(packages, vpattern = "Changes in version", render = TRUE,
        rawHTML = FALSE)
{
    packages <- setNames(packages, packages)
    listNEWS <- lapply(packages, function(pkg) {
        nloc <- .findNEWSfile(pkg)
        newstext <- readLines(nloc)
        .checkPkgInNews(pkg, newstext)
        newstext <- .replaceAt(newstext)
        c(paste0("# ", pkg), "", newstext, "")
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
        htmlfile <- tempfile(fileext = ".html")
        writeLines(text = newsfeed, con = mdfile)
        if (!requireNamespace("rmarkdown", quietly = TRUE))
            stop("Install 'rmarkdown' to use 'render=TRUE'")
        newspage <- rmarkdown::render(mdfile, output_file = htmlfile,
            output_format = rmarkdown::html_fragment(self_contained = FALSE),
            quiet = TRUE, encoding = "UTF-8")
        browseURL(newspage)
        if (rawHTML)
            return(htmlfile)
    }
    if (requireNamespace("clipr", quietly=TRUE) && clipr::clipr_available()) {
        message("News copied to clipboard")
        clipr::write_clip(newsfeed)
    }
    newsfeed
}
