#include <Rcpp.h>
#include "spdt.h"


// [[Rcpp::depends(sf)]]

#include <sf.h>

// can I call a CPP function that's included in the 'sf' package:


//std::vector<GEOSGeom> geometries_from_encoded(GEOSContextHandle_t hGEOSCtxt, Rcpp::List encoded, int *dim = NULL) {
//
//	Rcpp::List wkblst = CPL_write_wkb(encoded, true);
//
//	std::vector<GEOSGeom> g(encoded.size());
//	GEOSWKBReader *wkb_reader = GEOSWKBReader_create_r(hGEOSCtxt);
//	for (int i = 0; i < encoded.size(); i++) {
//		Rcpp::RawVector r = wkblst[i];
//		g[i] = GEOSWKBReader_read_r(hGEOSCtxt, wkb_reader, &(r[0]), r.size());
//	}
//	GEOSWKBReader_destroy_r(hGEOSCtxt, wkb_reader);
//	return g;
//}


// TODO:
// - decode polyline
// - formats to sfc
// - calls sf::CPL_geos_binop() at the Rcpp level

// [[Rcpp::export]]
Rcpp::List polyline_binops(Rcpp::List sfc0, Rcpp::List sfc1, std::string op, double par = 0.0,
                           std::string pattern = "", bool sparse = true, bool prepared = false){

	// https://stackoverflow.com/questions/38703682/calling-function-from-package-in-rcpp-code

	// Obtain environment containing function
	//Rcpp::Environment package_env("package:sf");
	//Rcpp::Rcout << "env: " << package_env << std::endl;
  //Rcpp::Rcout <<	package_env.get("CPL_geos_binop") << std::endl;
	//Make function callable from C++
	//Rcpp::Function rfunction = package_env.get("CPL_geos_binop");
	//Rcpp::Rcout << "rfunction: " << std::endl;

//	Rcpp::List sfc0;
//	Rcpp::List sfc1;
//	std::string op;
//	double par = 0.0;
//	std::string pattern = "";
//	bool sparse = true;
//	bool prepared = false;

//	rfunction(sfc0, sfc1, op, par, pattern, sparse, prepared);

  //CPL_geos_binop(sfc0, sfc1, op, par, pattern, sparse, prepared);

  //sf::CPL_read_wkb(Rcpp::List sfc0, false, false)


	return Rcpp::List::create(_["lat"] = 0);
}






