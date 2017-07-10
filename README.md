
## Spatial Data Table

## Summary

A `spatial.data.table` object is an extension of `data.table`. All the usual operations on a `data.table` (should) work within a `spatial.data.table` too. If not, please let me know by filing an issue.

This package includes convenience functions for doing spatial calculations with data in `data.table` and `spatial.data.table` objects. Notably I have re-written a set of `geosphere::dist_` functions in C++ (using `Rcpp`) by stripping out some of the unnecessary matrix-conversions. The functions also work in the `j` argument of `data.table`, so as per usual `data.table` operations you only have to pass in un-quoted column names.

You can also 

- convert `sp` and `sf` objects into `spatial.data.table` using `toSDT()`
- encod `sf` objects (LINESTRINGS, POLYGONS and MULTIPOLYGONS) into polylines (Google's polyline) using `EncodeSF()`


## Installation

Install the developent version using `devtools`

```
devtools::install_github("SymbolixAU/spatialdatatable")
```

## 

The driving factor behind developing `spatialdatatable` was to simplify the process of doing distance calculations within a `data.table`, which was driven by writing an [efficient haversine calculation](https://www.symbolix.com.au/blog-main/j26ynx6awfl32brcaxdjxnwalwmmbc) that falls naturally within the `j` argument of `data.table`.

I also wanted to make use of [Google's Encoded Polyline format](https://developers.google.com/maps/documentation/utilities/polylinealgorithm) for storing lines and polygons. The benefit of which is reduced object size

```
library(sf)

## example data that comes with the sf library
filename <- system.file("shape/nc.shp", package="sf")
sf <- st_read(filename)

object.size(sf)
135168 bytes

sdt <- EncodeSF(sf)

object.size(sdt)
50032 bytes

```

The `EncodeSF()` function takes the geometry information from the `sf` object and encodes it using Google's encoding algorithm (without losing any of the other data), and then stores it in a `spatial.data.table` object. 

```
sf
# Simple feature collection with 2 features and 1 field
# geometry type:  LINESTRING
# dimension:      XY
# bbox:           xmin: -80.19 ymin: 18.466 xmax: -64.757 ymax: 32.321
# epsg (SRID):    NA
# proj4string:    NA
#      id                        sf_line
# 1 line1 LINESTRING(-80.19 25.774, -...
# 2 line2 LINESTRING(-70.579 28.745, ...

sdt[1:5, .(.id, lineId, hole, NAME, polyline)]
#    .id lineId  hole      NAME                polyline
# 1:   1      1 FALSE      Ashe u_d|EtsgpNmmFphLyEbc...
# 2:   2      1 FALSE Alleghany or}|EhdznNyvA~Ce_Dli...
# 3:   3      1 FALSE     Surry }re|EbcajNakAf|BqKby...
# 4:   4      1 FALSE Currituck mtt|E`o|nMkpBhs@~I``...
# 5:   4      1 FALSE Currituck m~b~Ev``oMJcqDfwAe}O...
```







