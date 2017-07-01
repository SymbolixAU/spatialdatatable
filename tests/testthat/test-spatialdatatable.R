contenxt("spatialdatatable")

library(googleway)
library(sp)
library(sf)

## TODO:
## data.table 'global' options are unmodified

test_that("spatialdatatable created from sp & sf objects", {

	## SpatialPointsDataFrame
	sp <- SpatialPointsDataFrame(coords = tram_stops[, c("stop_lon", "stop_lat")], data = tram_stops)
	dt <- spToDT(sp)
	expect_true('spatialdatatable' %in% attr(dt, 'class'))

	## spLine
	spLine <- Line(tram_route[, c("shape_pt_lat", "shape_pt_lon")])
	dt <- spToDT(spLine)
	expect_true('spatialdatatable' %in% attr(dt, 'class'))

	##...

	## sfc MULTIPOINT
	p <- rbind(c(3.2,4), c(3,4.6), c(3.8,4.4), c(3.5,3.8), c(3.4,3.6), c(3.9,4.5))
	mp <- st_multipoint(p)
	dt <- spToDT(mp)
	expect_true('spatialdatatable' %in% attr(dt, 'class'))

	## sfg LINESTRING
	s1 <- rbind(c(0,3),c(0,4),c(1,5),c(2,5))
	ls <- st_linestring(s1)
	dt <- spToDT(ls)
	expect_true('spatialdatatable' %in% attr(dt, 'class'))

	## sfc MULTILINESTRING
	s2 <- rbind(c(0.2,3), c(0.2,4), c(1,4.8), c(2,4.8))
	s3 <- rbind(c(0,4.4), c(0.6,5))
	mls <- st_multilinestring(list(s1,s2,s3))
	dt <- spToDT(mls)
	expect_true('spatialdatatable' %in% attr(dt, 'class'))

	## sfc POLYGONS
	p1 <- rbind(c(0,0), c(1,0), c(3,2), c(2,4), c(1,4), c(0,0))
	p2 <- rbind(c(1,1), c(1,2), c(2,2), c(1,1))
	pol <-st_polygon(list(p1,p2))
	dt <- spToDT(pol)
	expect_true('spatialdatatable' %in% attr(dt, 'class'))

	## sfc MULTIPOLYGON
	p3 <- rbind(c(3,0), c(4,0), c(4,1), c(3,1), c(3,0))
	p4 <- rbind(c(3.3,0.3), c(3.8,0.3), c(3.8,0.8), c(3.3,0.8), c(3.3,0.3))[5:1,]
	p5 <- rbind(c(3,3), c(4,2), c(4,3), c(3,3))
	mpol <- st_multipolygon(list(list(p1,p2), list(p3,p4), list(p5)))
	dt <- spToDT(mpol)
	expect_true('spatialdatatable' %in% attr(dt, 'class'))


})


test_that("data.table update-by-reference creates new column", {

	spdt <- copy(spdt_melbourne)
	spdt[, p := polyline]
	expect_true(
		"p" %in% names(spdt)
	)

	## new column contains the 'spdt_polyline' attribute
	expect_true(
		names(attributes(spdt$p)) == "spdt_polyline"
	)

	expect_true(
		attributes(spdt$p) == "polyline"
	)

})

test_that("data.table update-by-references doesn't print", {
	spdt <- copy(spdt_melbourne)
	expect_silent(spdt[, p := polyline])
})

# test_that("spatialdatatable print truncates polyline column", {
#
# 	spdt <- copy(spdt_melbourne)
# 	expect_output(print(spdt))
#
# })

