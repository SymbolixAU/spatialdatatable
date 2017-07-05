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

// [[Rcpp::export]]
double rcppEarthRadius(){
	return spdt::EARTH_RADIUS;
}

