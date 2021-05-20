#' Change the NEWS.md file headings
#'
#' Some `NEWS.md` files have the package name in the heading. This is not
#' yet supported in the `collect` code. This convenience function will help
#' the user modify those headings to exclude the package name and include
#' the keywords `Changes in version` for aggregating news files across
#' packages. Version control of the NEWS files is highly recommended.
#' By default, the function saves a `*.bak` backup NEWS file in the package
#' directory.
#'
#' @inheritParams reformatNEWSmd
#'
#' @return Saves a "NEWS.md" file with substituted headers
#'
#' @examples
#'
#' # create phony DESC for usethis
#' # otherwise temp 'package' is not recognized
#' desc <- usethis:::build_description(
#'     basename(tempdir()), roxygen = TRUE, fields = list()
#' )
#' lines <- desc$str(by_field = TRUE, normalize = FALSE, mode = "file")
#' usethis:::write_over(
#'     file.path(tempdir(), "DESCRIPTION"), lines, quiet = TRUE
#' )
#'
#' tempNews <- file.path(tempdir(), "NEWS.md")
#' writeLines("# TempPackage 0.99.0", con = file(tempNews))
#' renameHeadings(pkg = tempdir())
#' readLines(tempNews)
#'
#' @export
renameHeadings <- function(pkg, dry.run = TRUE) {
    if (missing(pkg))
        stop("Provide a valid package name and directory: 'pkg'")
    newsfile <- .findNEWSfile(pkg)
    newslines <- readLines(newsfile)
    file.copy(newsfile, paste0(newsfile, backup))
    newslines <- gsub(
        "(^\\#+)(.*)([0-9].[0-9]{1,2}.[0-9]+)",
        "\\1 Changes in version \\3",
        newslines
    )
    if (dry.run)
        newslines
    else
        writeLines(newslines, con = file(newsfile))
}

