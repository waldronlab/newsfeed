#' Check that NEWS and DESCRIPTION package versions are correct
#'
#' The NEWS file contains version information that can be parsed and
#' checked against the package version in the DESCRIPTION file.
#'
#' @inheritParams collect
#'
#' @examples
#' \dontrun{
#' validate("MultiAssayExperiment")
#' validate("RaggedExperiment")
#' }
#'
#' @export
validate <- function(pkg, vpattern = "Changes in version") {
    newsfile <- .findNEWSfile(pkg)
    newslines <- readLines(newsfile)
    desc <- file.path(pkg, "DESCRIPTION")

    pkg_ver <- package_version(read.dcf(desc, "Version"))
    pkg_y_ver <- as.numeric(pkg_ver[, 2])
    diffeven <- pkg_y_ver %% 2
    ## handle special case of packages just before release
    if (pkg_y_ver == 99)
        pkg_y_ver <- 2

    newsind <- grep(vpattern, ignore.case = TRUE, newslines)
    versionheader <- newslines[newsind[1L]]
    newsver <- vapply(strsplit(versionheader, vpattern), `[`, character(1L), 2L)
    newsver <- package_version(trimws(newsver))
    news_y_ver <- newsver[, 2]

    valid <- FALSE
    if (news_y_ver == pkg_y_ver - diffeven)
        valid <- TRUE
    else if (news_y_ver == pkg_y_ver - (diffeven + 1)) {
        warning("Use future Bioconductor release version in the NEWS header")
        valid <- TRUE
    } else
        warning("NEWS version not up-to-date with current package version")

    valid
}

#' Obtain only the top part of the NEWS file
#'
#' This function is used internally for collating the latest NEWS after
#' validation with the `validate` function.
#'
#' @inheritParams validate
#'
#' @export
extract <- function(pkg, vpattern = "Changes in version") {
    newsfile <- .findNEWSfile(pkg)
    newslines <- readLines(newsfile)
    .checkPkgInNews(pkg, newslines)
    newslines <- .replaceAt(newslines)
    newsind <- grep(vpattern, ignore.case = TRUE, newslines)
    maxind <- length(newslines)
    if (!identical(length(newsind), 1L))
        maxind <- newsind[[2L]] - 1L
    newstext <- newslines[seq_len(maxind)]
    c(paste0("# ", pkg), "", newstext, "")
}

