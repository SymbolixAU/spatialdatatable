.onLoad <- function(libname, pkgname){

	opts = c("spatialdatatable.print.polyline" = 20L)

	for (i in setdiff(names(opts), names(options()))) {
		eval(parse(text = paste0("options(", i, "=", opts[i], ")")))
	}

}
