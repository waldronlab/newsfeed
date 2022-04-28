newsfeed
================

Compile NEWS files from several packages

## Install and load

``` r
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

if (!requireNamespace("newsfeed", quietly = TRUE))
    BiocManager::install("waldronlab/newsfeed")

library(newsfeed)
```

## Optional packages

  - clipr - allows the user to send the collection of NEWS files to the
    clipboard
  - rmarkdown - when `render = TRUE` in `collect`, the package will show
    an HTML page of NEWS updates

## Moving to the base packages directory

Users should move one level up from the package directory to be able to
find the NEWS files in the package:

``` r
setwd("..")
```

In this case, when compiling the `Rmd` file, I move one level up.

## Compiling NEWS files

``` r
collect("newsfeed", render = FALSE)
#>  [1] "newsfeed"                                                                  
#>  [2] "----------------------------------------------------------------"          
#>  [3] ""                                                                          
#>  [4] "## Changes in version 0.1.0"                                               
#>  [5] ""                                                                          
#>  [6] "### New features"                                                          
#>  [7] ""                                                                          
#>  [8] "* Restricts to only one `NEWS` file per package"                           
#>  [9] "* `collect` function allows the extraction of the latest news for an"      
#> [10] "installed package"                                                         
#> [11] "* `translate` convenience function moves plain `NEWS` files to `NEWS.md`" 
#> [12] ""                                                                          
#> [13] "### Bug fixes and minor improvements"                                      
#> [14] ""                                                                          
#> [15] "* Checks current packages for malformed news files. Those with the package"
#> [16] "name in the first line are not allowed (incorrect formatting)"             
#> [17] ""                                                                          
#> [18] ""
```

## Reading the NEWS

Here is how the NEWS collection would look if all NEWS files were
written in `NEWS.md` format:

<div id="newsfeed" class="section level2">

<h2>

newsfeed

</h2>

</div>

<div id="changes-in-version-0.1.0" class="section level2">

<h2>

Changes in version 0.1.0

</h2>

<div id="new-features" class="section level3">

<h3>

New features

</h3>

<ul>

<li>

Restricts to only one <code>NEWS</code> file per package

</li>

<li>

<code>collect</code> function allows the extraction of the latest news
for an installed package

</li>

<li>

<code>translate</code> convenience function moves plain
<code>NEWS</code> files to <code>NEWS.md</code>

</li>

</ul>

</div>

<div id="bug-fixes-and-minor-improvements" class="section level3">

<h3>

Bug fixes and minor improvements

</h3>

<ul>

<li>

Checks current packages for malformed news files. Those with the package
name in the first line are not allowed (incorrect formatting)

</li>

</ul>

</div>

</div>
