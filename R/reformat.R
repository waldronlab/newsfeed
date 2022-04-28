#' Convert a NEWS file to work with pkgdown
#'
#' This function will take an existing NEWS.md file and convert it to
#' pkgdown readable format. The former format should have headings that begin
#' with
#' \itemize{
#'     \item{CHANGES for 'CHANGES IN VERSION'}
#'     \item{'New' for 'New features'}
#'     \item{'Bug' for 'Bug fixes and minor improvements'}
#' }
#' These headings usually begin with 'h2' headers or double hashtag. An n-1
#' operation is performed on these headings (if the heading had two hashtags
#' 'h2', they are now converted to one hashtag 'h1').
#'
#' @inheritParams makeNEWSmd
#'
#' @param backup character(1) The file extension to add for backing up the
#'     original news file (default: '.bak')
#'
#' @return Saves a "NEWS.md" file with alternative format
#'
#' @export
reformat <- function(pkg = ".", backup = ".bak") {
    newsfile <- .findNEWSfile(pkg)
    dpkg <- devtools::as.package(pkg)
    pkg <- dpkg[["package"]]
    newslines <- readLines(newsfile)

    file.rename("NEWS.md", paste0("NEWS.md", backup))
    newslines <- gsub("# Changes in version", paste0(" ", pkg), newslines,
        ignore.case = TRUE)
    newslines <- gsub("# New features", " New features", newslines, fixed = TRUE)
    newslines <- gsub("# Bug", " Bug", newslines, fixed = TRUE)
    writeLines(newslines, "NEWS.md")
}

