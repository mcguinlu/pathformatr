# pathformatr 0.1.0.900

* Name change from `herehelper` to `pathformatr`. Function names updated also.
* Support for cleaning `file.path()` calls was added to `format_path()`. The function calls to be targeted for cleaning can be controlled using the `fns` argument.
* A new function, `format_all_paths()` was added to clean all `here()` and `file.path()` calls in the active document, rather than those highlighted. The function provides a print out of the number of each call it has found and cleaned.

* Initial working version of the package.
* Added a `NEWS.md` file to track changes to the package.

