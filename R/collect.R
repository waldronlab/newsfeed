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

collect <- function(packageList) {
    packageList <- setNames(packageList, packageList)
    pkgs <- readLines(packageList)
    unlist(lapply(pkgs, function(pkg) {
        readLines(.findNEWSfile(pkg))
    }))
}
