#include <Rcpp.h>
#include "spdt.h"

using namespace Rcpp;


double isLeft(double p0x, double p0y, double p1x, double p1y, double p2x, double p2y){
	return ((p1x - p0x) * (p2y - p0y) - (p2x - p0x) * (p1y - p0y));
}


bool isPolygonClosed(double startX, double endX, double startY, double endY){
	return (startX == endX && startY == endY);
}

Rcpp::NumericVector ClosePolygon(Rcpp::NumericVector polyVector){
	polyVector.push_back(polyVector[0]);
	return polyVector;
}

double windingNumber(double pointX, double pointY,
                     NumericVector vectorX, NumericVector vectorY){

	int windingNumber = 0;  // winding number counter
	int nVectorSize = vectorX.size() - 1;

	// check if the polygon is closed
	if(!isPolygonClosed(vectorX[0], vectorX[nVectorSize], vectorY[0], vectorY[nVectorSize])){

		// close polygon
		vectorX = ClosePolygon(vectorX);
		vectorY = ClosePolygon(vectorY);
	}


	int n = vectorX.size() - 1; // number of rows of the polygon vector
	// compute winding number

	// loop all points in the polygon vector
	for (int i = 0; i < n; i++){
		if (vectorY[i] <= pointY){
			if (vectorY[i + 1] > pointY){
				if (isLeft(vectorX[i], vectorY[i], vectorX[i + 1], vectorY[i + 1], pointX, pointY) > 0){
					++windingNumber;
				}
			}
		}else{
			if (vectorY[i + 1] <= pointY){
				if (isLeft(vectorX[i], vectorY[i], vectorX[i + 1], vectorY[i + 1], pointX, pointY) < 0){
					--windingNumber;
				}
			}
		}
	}
	return windingNumber;
}

// Comparing a data.table of points and a data.table of polygons
// - whcih points fall in which polygons
// - RETURN: a data.table of the pointIds and the associated polygonId that they'r ein

// METHOD:
// - for each polygon, check all points
// - the polygon data.table will have an "ID", and "lineId"
// - where does the loop get called?
// - send whole vector of data.table polyIds and lineIds;
// - need to find the unique IDs of the polygons,
// - then in cpp, need to subset the polygons....

// - using data.table, dt[, WindingNumber(lat, lon, dt_points), by = .(polyId, lineId)]
// - this will internally loop over each polygon, and call 'windingNumber'
// - for all the points

// [[Rcpp::export]]
NumericVector rcppPointsInPolygon(NumericVector pointsId,
                                  NumericVector pointsX, NumericVector pointsY,
                                  NumericVector vectorX, NumericVector vectorY){

	int nPoints = pointsId.size();
	NumericVector pointsInPolygon;

	for (int iPoint = 0; iPoint < nPoints; iPoint++){

		if (windingNumber(pointsX[iPoint], pointsY[iPoint], vectorX, vectorY) != 0 ){
			pointsInPolygon.push_back(pointsId[iPoint]);
			}
	}

	return pointsInPolygon;
}

// [[Rcpp::export]]
double rcppWindingNumber(double pointX, double pointY,
                     NumericVector vectorX, NumericVector vectorY){
	return windingNumber(pointX, pointY, vectorX, vectorY);
}

