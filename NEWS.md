## Changes in version 0.1.0

### New features

* Restricts to only one `NEWS` file per package
* `collect` function allows the extraction of the latest news for an
installed package
* `makeNEWSmd` convenience function moves plain `NEWS` files to `NEWS.md`

### Bug fixes and minor improvements

* Checks current packages for malformed news files. Those with the package
name in the first line are not allowed (incorrect formatting)

