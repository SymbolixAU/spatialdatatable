context("calculations")


test_that("anitpodes are correct",{

	expect_equal(
		spatial.data.table:::antipodeLat(-10),
		10
	)

	expect_equal(
		spatial.data.table:::antipodeLat(0),
		0
	)

	expect_equal(
		spatialdatatable:::antipodeLon(0),
		-180
	)

	expect_equal(
		spatial.data.table:::antipodeLon(-0.40),
		179.6
	)

	expect_equal(
		dtAntipode(c(-37, 144)),
		c(37, -36)
	)



})


