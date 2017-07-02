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
	expect_equal(WindingNumber(pointX, pointY, polyX, polyY), 1)


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
	polyX = c(-38.1, -38.1, -36.9, -36.9, -38.1)  ## latitude of Melbourne
	polyY = c(144.9, 144.3, 144.3, 144.9, 144.9)  ## longitude of Melbourne

	expect_equal(
		WindingNumber(pointX, pointY, polyX, polyY),
		0
	)

	## - point to the south of the polygon that crosses 0 longitude
	## - should be -ve
	polyX = c(51, 52, 52, 51, 51)           ## latitude of UK-ish
	polyY = c(1.05, 1.05, -1.05, -1.05, 1.05)   ## longitude corssing 0

	## roughly Greenwhich
	pointX = 50.9                          ## latitude of UK-ish
	pointY = 0                                  ## longitude of greenwhich

	#plot to check
	# library(googleway)
	# df <- data.frame(lat = polyX, lon = polyY)
	# mapKey <- read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_MAP_KEY")
	#
	# google_map(key = mapKey) %>%
	# 	add_markers(data = data.frame(lat = pointX, lon = pointY)) %>%
	# 	add_polylines(data = df, lat = "lat", lon = "lon")


	## point is outside the polygon
	expect_equal(
		WindingNumber(pointX, pointY, polyX, polyY),
		0
	)

	## point on the line of the polygon
	pointX = 51
	pointY = 0

	# google_map(key = mapKey) %>%
	# 	add_markers(data = data.frame(lat = pointX, lon = pointY)) %>%
	# 	add_polylines(data = df, lat = "lat", lon = "lon")

	expect_equal(
		WindingNumber(pointX, pointY, polyX, polyY),
		-1
	)


	## test polygon surrounding [0,0]
	polyX = c(-0.5, 0.5, 0.5, -0.5, -0.5)
	polyY = c(1.05, 1.05, -1.05, -1.05, 1.05)

	## roughly Greenwhich
	pointX = 0
	pointY = 0
	df <- data.frame(lat = polyX, lon = polyY)

	# google_map(key = mapKey) %>%
	# 	add_markers(data = data.frame(lat = pointX, lon = pointY)) %>%
	# 	add_polylines(data = df, lat = "lat", lon = "lon")

	## point is inside the polygon
	expect_false(
		WindingNumber(pointX, pointY, polyX, polyY) == 0
	)

	## point to the south of the polygon
	pointX = -1
	pointY = 0

	# google_map(key = mapKey) %>%
	# 	add_markers(data = data.frame(lat = pointX, lon = pointY)) %>%
	# 	add_polylines(data = df, lat = "lat", lon = "lon")

	expect_equal(
		WindingNumber(pointX, pointY, polyX, polyY),
		0
	)

	## point to the east of the polygon
	pointX = 0
	pointY = 1.1

	expect_equal(
		WindingNumber(pointX, pointY, polyX, polyY),
		0
	)

	## point to the north of the polygon
	pointX = 1
	pointY = 0

	expect_equal(
		WindingNumber(pointX, pointY, polyX, polyY),
		0
	)

	## point to the west of the polygon
	pointX = 0
	pointY = -1.1

	expect_equal(
		WindingNumber(pointX, pointY, polyX, polyY),
		0
	)

})


