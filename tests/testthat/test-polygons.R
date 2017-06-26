context("polygons")


test_that("winding number works", {

	## expect point inside polygon
	polyX = c(1, 1, -1, -1, 1)
	polyY = c(-1, 1, 1, -1, -1)

	pointX = 0
	pointY = 0

	expect_gt(WindingNumber(pointX, pointY, polyX, polyY), 0)

	## expect point outside polygon
	pointX = 2
	pointY = 2
	expect_equal(WindingNumber(pointX, pointY, polyX, polyY), 0)

	## expect point on line / border of polygon
	# pointX = 1
	# pointY = 0.5
	# WindingNumber(pointX, pointY, polyX, polyY)

	## expect non-closed polygon
	polyX = c(1, 1, -1, -1)
	polyY = c(-1, 1, 1, -1)

	pointX = 0
	pointY = 0
	expect_equal(WindingNumber(pointX, pointY, polyX, polyY, debugIsClosed = T), -1)

	expect_equal(
		WindingNumber(pointX, pointY, polyX, polyY, debugClosePoly = T),
		length(polyX) + 1
	)


	## using lat/lon coordinates
	## - point inside polygon
	pointX = -37.9
	pointY = 144.5

	polyX = c(-38.1, -38.1, -36.9, -36.9)
	polyY = c(144.9, 144.3, 144.3, 144.9)

	expect_equal(
		WindingNumber(pointX, pointY, polyX, polyY),
		1
	)

	## - point outside polygon
	pointX = -37.9
	pointY = 144.9
	polyX = c(-38.1, -38.1, -36.9, -36.9, -38.1)
	polyY = c(144.9, 144.3, 144.3, 144.9, 144.9)

	expect_equal(
		WindingNumber(pointX, pointY, polyX, polyY),
		0
	)

	## - point to the south of the polygon that crosses 0 latitude
	## - should be -ve
	polyX = c(1.05, 1.05, -89.5, -89.5, 1.05)
	polyY = c(53.0, 53.5, 53.5, 53.0, 53.0)

	## roughly Greenwhich
	pointX = 0
	pointY = 52.89

	expect_equal(
		WindingNumber(pointX, pointY, polyX, polyY),
		-1
	)





})


