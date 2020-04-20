# newsfeed
Compile NEWS files from several packages

## Installation

```r
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("waldronlab/newsfeed")
```

## Optional packages

* clipr - allows the user to send the collection of NEWS files to the clipboard.
* rmarkdown - when `render = TRUE` in `collect`, the package will  show an HTML
page of NEWS updates

## Compiling NEWS files

```r
collect("newsfeed")
## sent to clipboard
```

## Reading the NEWS

```r
collect("newsfeed", render = TRUE)
```
