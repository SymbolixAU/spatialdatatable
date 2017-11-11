#include <Rcpp.h>
#include "spdt.h"

using namespace Rcpp;


void vectorCheck(NumericVector v1, NumericVector v2){
	if(v1.size() != v2.size()){
		stop("Vector lengths differ");
	}
}

double toRadians(double deg){
	return deg * spdt::DEGREE;
}

double toDegrees(double rad){
	return rad * spdt::RADIAN;
}

double normaliseLonDeg(double deg){
	return fmod(deg - 180.0, 360.0) + 180.0;
}


std::string single_wkt(Rcpp::List latLonList){

	NumericVector lats = latLonList["lat"];
	NumericVector lons = latLonList["lon"];

	int n = lats.size();
	std::ostringstream ossOut;

	ossOut << "(";
	for(int i = 0; i < (n - 1); i ++) {
		ossOut << lons[i] << " " << lats[i] << ", " ;
	}

	ossOut << lons[(n - 1)] << " " << lats[(n - 1)] << ")";

	return ossOut.str();
}
