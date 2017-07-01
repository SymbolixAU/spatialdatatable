context("calculations")


test_that("anitpodes are correct",{

	expect_equal(
		spatialdatatable:::antipodeLat(-10),
		10
	)

	expect_equal(
		spatialdatatable:::antipodeLat(0),
		0
	)

	expect_equal(
		spatialdatatable:::antipodeLon(0),
		-180
	)

	expect_equal(
		spatialdatatable:::antipodeLon(-0.40),
		179.6
	)

	expect_equal(
		dtAntipode(-37, 144),
		list(37, -36)
	)

})


