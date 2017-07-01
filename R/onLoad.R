.onLoad <- function(libname, pkgname){

	dtprintrows <- getOption("datatable.print.nrows")                             # original datatable.print.nrows

	opts = c("spatialdatatable.print.polyline" = 20L,                             # nchars to print
					 "spatialdatatable.datatable.print.nrows" = dtprintrows               # options specified for datatable.print.nrows
					 )

	for (i in setdiff(names(opts), names(options()))) {
		eval(parse(text = paste0("options(", i, "=", opts[i], ")")))
	}

}
