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

collect <- function(packageList, outFile = tempfile()) {
    packageList <- setNames(packageList, packageList)
    listNEWS <- lapply(packageList, function(pkg) {
        readLines(.findNEWSfile(pkg))
    })

    indx <- lapply(listNEWS, function(pkgLines) {
        vers <-
            head(
                grep("Changes in version", ignore.case = TRUE, pkgLines),
            2L)
        if (identical(length(vers), 1L))
            length(pkgLines)
        else
            vers[[2L]] - 1L
    })
    newslines <- mapply(function(x, y) x[seq_len(y)], x = listNEWS, y = indx)
    writeLines(text = unlist(newslines), con = file(outFile))
}

