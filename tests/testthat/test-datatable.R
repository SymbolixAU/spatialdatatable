context("data.table")

## tests that data.table operations still wokr

## joins X[Y]
## :=
##

test_that("spatialdadtatable respects data.table X[Y] joins", {

	spdt <- copy(spdt_melbourne[polygonId == 1, setdiff( names(spdt_melbourne), "polyline"), with = F])
	spdt2 <- copy(spdt_melbourne[polygonId == 1, .(polygonId, polyline)])

	expect_silent(
		spdt <- spdt[ spdt2, on = "polygonId", nomatch = 0]
	)

	expect_true('polyline' %in% names(spdt))

})
