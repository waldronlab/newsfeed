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
        pkg <- devtools::as.package(".")[["package"]]
        newslines <- readLines(newsfile)
        .checkPkgName(pkg, newslines)
        writeLines(newslines, "NEWS.md")
        resp <- readline(
            paste0("Remove old news file at '", newsfile, "'? [y/n]: ")
        )
        resp <- substr(tolower(resp), 1, 1)
        if (identical(resp, "y"))
            file.remove(newsfile)
        ignoredNews <- grepl("NEWS", readLines(".Rbuildignore"))
        if (ignoredNews)
            warning("Remove NEWS* file from '.Rbuildignore'")
    }
    TRUE
}

