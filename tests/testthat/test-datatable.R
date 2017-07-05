context("data.table")

## tests that data.table operations still wokr

## joins X[Y]
## :=
##

test_that("spatialdadtatable respects data.table X[Y] joins", {

	sdt <- copy(sdt_melbourne[polygonId == 1, setdiff( names(sdt_melbourne), "polyline"), with = F])
	sdt2 <- copy(sdt_melbourne[polygonId == 1, .(polygonId, polyline)])

	expect_silent(
		sdt <- sdt[ sdt2, on = "polygonId", nomatch = 0]
	)

	expect_true('polyline' %in% names(sdt))

})
