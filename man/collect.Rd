% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/collect.R
\name{collect}
\alias{collect}
\title{Compile NEWS files from several packages}
\usage{
collect(
  packages,
  vpattern = "Changes in version",
  render = TRUE,
  rawHTML = FALSE
)
}
\arguments{
\item{packages}{character() A vector of packages with NEWS files}

\item{vpattern}{character(1) The 'grep' input for searching the versioning
line in the NEWS files. This usually starts with 'Changes in version'
but may differ.}

\item{render}{logical(1) Whether to produce an HTML document for viewing
(default: TRUE)}

\item{rawHTML}{logical(1) Whether to return the raw HTML text when
`render = TRUE` (default: FALSE)}
}
\description{
This package will take the first chunk of a NEWS file and
return it as a character vector. Users should call this function within
a folder *above* all of the packages in the 'packages' argument. This will
ensure that the proper NEWS path is obtained.
}
\details{
The NEWS file location can be in one of four locations relative
   to the package directory:
    \itemize{
         \item{"NEWS.md"}
         \item{"NEWS"}
         \item{"inst/NEWS"}
         \item{"inst/NEWS.md"}
         \item{"inst/NEWS.Rd"}
    }
   Obtained from Bioconductor NEWS guidelines:
   \url{https://www.bioconductor.org/developers/package-guidelines/#news}
}
\examples{

collect("newsfeed")
\dontrun{
    pkgs <- c(
        "MultiAssayExperiment", "curatedTCGAData", "TCGAutils",
        "cBioPortalData", "SingleCellMultiModal", "RTCGAToolbox",
        "RaggedExperiment", "terraTCGAdata", "BiocBaseUtils", "TENxIO",
        "BiocHubsShiny"
    )
    stopifnot(all(dir.exists(pkgs)))
    collect(pkgs)
}
}
