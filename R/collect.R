.findNEWSfile <- function(pkg) {
    pkgLoc <- system.file(package = pkg)
    newsfile <- dir(pkgLoc, pattern = "^NEWS", recursive = TRUE, full.names = TRUE)
    if (length(newsfile) > 1) {
        allNEWS <- basename(newsfile) == "NEWS"
        if (identical(sum(allNEWS), 1L))
            newsfile <- newsfile[allNEWS]
        else
            stop("Multiple matching NEWS files found")
    }
    newsfile
}

collect <-
    function(packages, out = tempfile(), vpattern = "Changes in version")
{
    packages <- setNames(packages, packages)
    listNEWS <- lapply(packages, function(pkg) {
        readLines(.findNEWSfile(pkg))
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
    newslines <- mapply(function(x, y) x[seq_len(y)], x = listNEWS, y = indx)
    writeLines(text = unlist(newslines), con = file(out))
}

