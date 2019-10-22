#' Create a NEWS.md file from NEWS file
#'
#' This function will add a package name line to the
#' current NEWS file and write a NEWS.md file for
#' viewing on GitHub. Future iterations will simplify
#' formatting changes to the NEWS file so that it can
#' be converted to a markdown file. Current files
#' should have markdown syntax in the NEWS file.
#'
#' @param newsfile character(1) The location of the NEWS file usually in
#'     'inst/NEWS' (default)
#' @param overwite logical(1) Whether to overwrite the existing NEWS.md file
#'     (default: FALSE)
#'
#' @return Saves a file with the name "NEWS.md" in the package directory
#'
#' @export
makeNEWSmd <- function(newsfile = "inst/NEWS", overwrite = FALSE) {
    if (file.exists("NEWS.md") && !overwrite) {
        stop("NEWS.md file exists")
    } else {
        newslines <- readLines(newsfile)
        pkginnews <- grepl(pkg, newslines[1])
        if (pkginnews)
            stop("The NEWS file should not contain the package name;",
                "\n Test package with 'utils::news'")
        writeLines(newslines, "NEWS.md")
    }
}

