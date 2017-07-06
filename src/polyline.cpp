#include <Rcpp.h>
#include "sdt.h"

using namespace Rcpp;

// Reference:
// https://github.com/googlemaps/android-maps-utils/blob/7368f6157560c6d132de55f27e1147cd6a43c961/library/src/com/google/maps/android/SphericalUtil.java



// ------------------------------------------------------
// C++ implementation of the google api polyline decoder
// https://developers.google.com/maps/documentation/utilities/polylineutility
//
// This code is adapted from an Open Frameworks implementation
// and used in this package with the permission of the author
// https://github.com/paulobarcelos/ofxGooglePolyline
//
// ------------------------------------------------------

// [[Rcpp::export]]
DataFrame rcpp_decode_pl(std::string encoded){
	int len = encoded.size();
	int index = 0;
	float lat = 0;
	float lng = 0;

	Rcpp::NumericVector  pointsLat;
	Rcpp::NumericVector pointsLon;

	while (index < len){
		char b;
		int shift = 0;
		int result = 0;
		do {
			b = encoded.at(index++) - 63;
			result |= (b & 0x1f) << shift;
			shift += 5;
		} while (b >= 0x20);
		float dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));
		lat += dlat;

		shift = 0;
		result = 0;
		do {
			b = encoded.at(index++) - 63;
			result |= (b & 0x1f) << shift;
			shift += 5;
		} while (b >= 0x20);
		float dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));
		lng += dlng;

		pointsLat.push_back(lat * (float)1e-5);
		pointsLon.push_back(lng * (float)1e-5);
	}

	return DataFrame::create(Named("lat") = pointsLat, Named("lon") = pointsLon);
}

Rcpp::String EncodeNumber(int num){

	std::string out_str;

	while(num >= 0x20){
		out_str += (char)(0x20 | (int)(num & 0x1f)) + 63;
		num >>= 5;
	}

	out_str += char(num + 63);
	return out_str;
}

Rcpp::String EncodeSignedNumber(int num){

	int sgn_num = num << 1;

	if (sgn_num < 0) {
		sgn_num = ~sgn_num;
	}

	return EncodeNumber(sgn_num);
}

// [[Rcpp::export]]
Rcpp::String rcpp_encode_pl(Rcpp::NumericVector latitude,
                            Rcpp::NumericVector longitude,
                            int num_coords){
	int plat = 0;
	int plon = 0;
	String output_str;

	for(int i = 0; i < num_coords; i++){
		int late5 = latitude[i] * 1e5;
		int lone5 = longitude[i] * 1e5;

		output_str += EncodeSignedNumber(late5 - plat);
		output_str += EncodeSignedNumber(lone5 - plon);

		plat = late5;
		plon = lone5;
	}
	return output_str;
}


// Length of an encoded polyline
// - calculate the haversine distance between successive coordinates
// [[Rcpp::export]]
Rcpp::NumericVector rcppPolylineDistance(Rcpp::StringVector encodedStrings){

	int len = encodedStrings.size();

	int nCoords;
	Rcpp::DataFrame df_coords;
	float thisDistance;
	Rcpp::DoubleVector lats;
	Rcpp::DoubleVector lons;
	Rcpp::DoubleVector result(len);
	double latf;
	double lonf;
	double latt;
	double lont;

	for(int i = 0; i < len; i++){

		std::string thisEncoded = Rcpp::as< std::string >(encodedStrings[i]);
		df_coords = rcpp_decode_pl(thisEncoded);
		lats = df_coords["lat"];
		lons = df_coords["lon"];

		// calculate the total distance between each successive pair of coordinates
		nCoords = lats.size() - 1;
		thisDistance = 0;
		for(int j = 0; j < nCoords; j++){

			//Rcpp::Rcout.precision(10);

			//Rcpp::Rcout << lats[j] << std::fixed << "," << lons[j] << std::endl;
			//Rcpp::Rcout << lats[j + 1] << std::fixed << "," << lons[j + 1] << std::endl;

			latf = toRadians(lats[j]);
			lonf = toRadians(lons[j]);
			latt = toRadians(lats[j + 1]);
			lont = toRadians(lons[j + 1]);

		  //Rcpp::Rcout << latf << std::fixed << "," << lonf << std::endl;
			//Rcpp::Rcout << latt << std::fixed <<  "," << lont << std::endl;

			//Rcpp::Rcout << "rcpp_polyline_distance distance: " << dist << std::endl;
			thisDistance += distanceHaversine(latf, lonf, latt, lont, 1000000000);
			//Rcpp::Rcout << "rcpp_polyline_distance distance: " << dist << std::endl;
		}
		result[i] = thisDistance;


		//double dx = distanceHaversine(-38.39360, 144.7876, -38.39354, 144.7875, 1.00000001);
	  //Rcpp::Rcout << "haversine2: "<<	dx << std::endl;

	}

	return result;

}

// Returns the signed area of a traingle which has the north pole as vertex.
double polarTriangleArea(double tant, double lont, double tanf, double lonf){
	double dlon = lont - lonf;
	double t = tant * tanf;
	return 2 * atan2(t * sin(dlon), 1 + (t * cos(dlon)));
}

// the signed area can be used to determine the orientation of the path
double computeSignedArea(NumericVector lats, NumericVector lons){

	int nCoords = lats.size();
	double totalArea = 0;

	double latf;
	double lonf;
	//double latt;
	double lont;
	double tanf;
	double tant;

	if(nCoords == 1) return 0;
	// polyline of 1 coordinate can't be closed
	// polyline of > 2 coordinates, may need closing

	if(!isPolygonClosed(lats[0], lats[nCoords], lons[0], lons[nCoords])){
		lats = ClosePolygon(lats);
		lons = ClosePolygon(lons);
		nCoords++;   // because we've added a point
	}

	latf = lats[(nCoords - 1 )];
	lonf = lons[(nCoords - 1 )];

	tanf = tan( (sdt::PI_OVER_2 - toRadians(latf) ) * 0.5 );
	lonf = toRadians(lonf);

	for(int j = 0; j < nCoords; j++){

		tant = tan( (sdt::PI_OVER_2 - toRadians(lats[j]) ) * 0.5 );
		lont = toRadians(lons[j]);
		totalArea += polarTriangleArea(tant, lont, tanf, lonf);

		tanf = tant;
		lonf = lont;
	}

	return totalArea * (sdt::EARTH_RADIUS * sdt::EARTH_RADIUS);
}

// [[Rcpp::export]]
NumericVector rcppPolylineArea(Rcpp::StringVector encodedStrings){

	int len = encodedStrings.size();

	Rcpp::DataFrame df_coords;
	Rcpp::DoubleVector lats;
	Rcpp::DoubleVector lons;
	Rcpp::DoubleVector result(len);

	for(int i = 0; i < len; i++){

		std::string thisEncoded = Rcpp::as< std::string >(encodedStrings[i]);
		df_coords = rcpp_decode_pl(thisEncoded);
		lats = df_coords["lat"];
		lons = df_coords["lon"];

		// calculate the total distance between each successive pair of coordinates
		result[i] = fabs(computeSignedArea(lats, lons));
	}

	return result;

}




//DataFrame rcpp_decode_pl( std::string encoded );
//Rcpp::String rcpp_encode_pl(Rcpp::NumericVector latitude,
//                            Rcpp::NumericVector longitude,
//                            int num_coords);

// Douglas Peucker
// needs to operate on earth (oblate spheroid)
// the algorithm will record the indices to keep,
// then subset the original polyline by those indeces
// the index array will be created with 0s
// then can filter out quite easily those that are greater than 0

void cppDouglasPeucker(NumericVector lats, NumericVector lons, int firstIndex, int lastIndex,
                       float distanceTolerance, LogicalVector& keepIndex){

	int pathLength = lats.size();
	int thisIndex = firstIndex;
	double maxDistance = 0.0;
	double thisDistance;
	double startLat = lats[firstIndex];
	double startLon = lons[firstIndex];
	double endLat = lats[lastIndex];
	double endLon = lons[lastIndex];

	if(pathLength < 3){
		// return points
	}

	if(lastIndex < firstIndex){
		// empty
	}else if(lastIndex == firstIndex){
		keepIndex[firstIndex] = true;
	}else{
		keepIndex[firstIndex] = true;

		for(int i = firstIndex + 1; i < lastIndex; i++){

  		// start & end are the coordinates of the end pionts of the track
			// lats[i]/lons[i] are the cooridnates of the POINT of interest

			// abs() called as the sign of the distance matters
			thisDistance = fabs(rcppDist2gc(startLat, startLon, endLat, endLon, lats[i], lons[i],
	                             distanceTolerance));

			if(thisDistance > maxDistance){
				maxDistance = thisDistance;
				thisIndex = i;
			}
		}
		if(maxDistance > distanceTolerance){
			// we've found a point.
			// Now recurse back into the algorithm to find another
			keepIndex[thisIndex] = true;
			cppDouglasPeucker(lats, lons, firstIndex, thisIndex, distanceTolerance, keepIndex);
			cppDouglasPeucker(lats, lons, thisIndex, lastIndex, distanceTolerance, keepIndex);
		}
	}
}

// [[Rcpp::export]]
Rcpp::StringVector rcppDouglasPeucker(Rcpp::StringVector polyline, double distanceTolerance){

  int nPolylines = polyline.size();
	Rcpp::StringVector resultPolylines(nPolylines);


	for (int i = 0; i < nPolylines; i++){

		DataFrame df = rcpp_decode_pl(Rcpp::as< std::string >(polyline[i]) );

		NumericVector lats = df["lat"];
		NumericVector lons = df["lon"];

		int firstIndex = 1;
		int lastIndex = df.nrow();

		int n = lats.size();
		LogicalVector keepIndex(n);

		cppDouglasPeucker(lats, lons, firstIndex, lastIndex, distanceTolerance, keepIndex);

		int keep = sum(keepIndex);
		resultPolylines[i] = rcpp_encode_pl(lats[keepIndex], lons[keepIndex], keep);

	}

	// keepIndex is now a logical vector of all the indices of the lats/lons to keep
	return resultPolylines;
}


// [[Rcpp::export]]
Rcpp::StringVector rcppSimplifyPolyline(Rcpp::StringVector polyline, double distanceTolerance,
                               double tolerance){

	// vertex cluster reduction
	int nPolylines = polyline.size();
	Rcpp::StringVector resultPolylines(nPolylines);

	for(int j = 0; j < nPolylines; j++){

		DataFrame df = rcpp_decode_pl(Rcpp::as< std::string >(polyline[j]) );

		int keepCounter = 0;
		int n = df.nrows() - 1;
		bool allGone = false;

		NumericVector lats = df["lat"];
		NumericVector lons = df["lon"];

		// I'm pre-allocating the length - then will only return those that are kept
		NumericVector keepLat(n);
		NumericVector keepLon(n);

		// loop over the data.frame points
		// only 'keep' those that are outside the tolerance range
		for (int i = 0; i < n; i++){

			if(distanceHaversine(lats[i], lons[i], lats[i + 1], lons[i + 1], tolerance) > distanceTolerance){
				keepLat[keepCounter] = lats[i];
				keepLon[keepCounter] = lons[i];
				keepCounter++;
			}
		}

		// if nothing has been kept; at least keep the first and last
		if(keepCounter == 0){
			allGone = true;
			keepCounter = 2;
		}

		NumericVector outLat(keepCounter);
		NumericVector outLon(keepCounter);

		if(allGone){
	    outLat[0] = lats[0];
			outLat[1] = lats[1];
			outLon[0] = lons[0];
			outLon[1] = lons[1];
		}else{

			for (int i = 0; i < keepCounter; i++) {
				outLat[i] = keepLat[i];
				outLon[i] = keepLon[i];
			}
		}

		resultPolylines[j] = rcpp_encode_pl(outLat, outLon, keepCounter);
	}

	return resultPolylines;
}




