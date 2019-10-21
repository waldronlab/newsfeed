.findNEWSfile <- function(pkg) {
    pkgLoc <- system.file(package = pkg)
    newsfile <- list.files(pkgLoc, pattern = "^NEWS", recursive = TRUE,
        full.names = TRUE)
    if (length(newsfile) > 1)
            stop("Multiple NEWS files found in package folder")
    newsfile
}

#' Compile NEWS files from several packages
#'
#' This package will take the first chunk of a NEWS file and
#' return it as a character vector
#'
#' @param packages A character vector of packages installed on the system
#' @param vpattern The 'grep' input for searching the versioning line in the
#'   NEWS files. This usually starts with 'Changes in version' but may differ.
#'
#' @examples
#'
#' collect("newsfeed")
#'
#' @export
collect <-
    function(packages, vpattern = "Changes in version")
{
    packages <- setNames(packages, packages)
    listNEWS <- lapply(packages, function(pkg) {
        nloc <- .findNEWSfile(pkg)
        .addPkg2NEWS(pkg = pkg, nfile = nloc)
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
    unname(unlist(Map(function(x, y) x[seq_len(y)], x = listNEWS, y = indx)))
}

