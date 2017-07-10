
## Spatial Data Table

A `spatialdatatable` object is an extension of `data.table`. All the usual operations on a `data.table` (should) work within a `spatialdatatable` too.

This package includes convenience functions for doing spatial calculations with data in `data.table` and `spatialdatatable` objects. Notably I have re-written a set of `geosphere::dist_` functions in C++ (using `Rcpp`) and stripping out some of the unnecessary matrix-conversions, so that the functions evaluate on columns of `data.table`.

You can also convert `sp` and `sf` objects into `spatialdatatable`.

Encoding lines and polygons into polylines (Google's polyilne)


Install the developent version using `devtools`

```
devtools::install_github("SymbolixAU/spatialdatatable")
```

