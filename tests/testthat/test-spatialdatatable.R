contenxt("spatialdatatable")

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

