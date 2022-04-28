#' Create a NEWS.md file from NEWS file
#'
#' This function will add a package name line to the
#' current NEWS file and write a NEWS.md file for
#' viewing on GitHub. Future iterations will simplify
#' formatting changes to the NEWS file so that it can
#' be converted to a markdown file. Current files
#' should have markdown syntax in the NEWS file.
#'
#' @param pkg character(1) The directory location of the package usually the
#'     current directory (default: ".")
#'
#' @param overwite logical(1) Whether to overwrite the existing NEWS.md file
#'     (default: FALSE)
#'
#' @return Saves a file with the name "NEWS.md" in the package directory
#'
#' @export
translate <- function(pkg = ".", overwrite = FALSE) {
    newsfile <- .findNEWSfile(pkg)
    if (length(newsfile) && !overwrite) {
        stop("NEWS file exists: ", newsfile)
    } else {
        dpkg <- devtools::as.package(pkg)
        pkg <- dpkg[["package"]]
        newslines <- readLines(filepath(pkg[["path"]], newsfile))
        .checkPkgInNews(pkg, newslines)
        writeLines(newslines, "NEWS.md")
        resp <- readline(
            paste0("Remove old news file, '", newsfile, "'? [y/n]: ")
        )
        resp <- substr(tolower(resp), 1, 1)
        if (identical(resp, "y"))
            file.remove(newsfile)
        ignoredNews <- grepl("NEWS", readLines(".Rbuildignore"),
            ignore.case = TRUE)
        if (ignoredNews)
            warning("Remove NEWS* file from '.Rbuildignore'")
    }
    TRUE
}

