## Changes in version 0.1.0

### New features

* Restricts to only one `NEWS` file per package
* `collect` function allows the extraction of the latest news for an
installed package
* `translate` convenience function moves plain `NEWS` files to `NEWS.md`
* `validate` provides a way to diagnose versioning issues in `NEWS` files

### Bug fixes and minor improvements

* Checks current packages for malformed news files. Those with the package
name in the first line are not allowed (incorrect formatting)

