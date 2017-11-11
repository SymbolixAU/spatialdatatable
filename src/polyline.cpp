#include <Rcpp.h>
#include "spdt.h"

using namespace Rcpp;

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
Rcpp::String rcpp_polyline_wkt(Rcpp::StringVector encodedStrings){

	// TODO:
	// if no 'by' clause, assume each row is a single WKT polygon, rather than
	// concatenate them all

	int encodedSize = encodedStrings.size();

	std::string out;
	std::string firstOut = "";
	std::string encoded;
	Rcpp::List decoded;

	std::ostringstream ossOutFirst;
	std::ostringstream ossOut;

	Rcpp::Rcout << "encoded size: " << encodedSize << std::endl;

	if(encodedSize > 1){
		for(int i = 0; i < (encodedSize - 1); i ++ ){
			encoded = Rcpp::as< std::string >(encodedStrings[i]);
			decoded = decode_polyline(encoded);
			out = single_wkt(decoded);
			ossOutFirst << out << ", ";
		}
		firstOut = ossOutFirst.str();
	}

	encoded = Rcpp::as< std::string >(encodedStrings[(encodedSize - 1)]);
	decoded = decode_polyline(encoded);
	out = single_wkt(decoded);

	ossOut << "POLYGON (" << firstOut << out << ")";

	return ossOut.str();
}


// [[Rcpp::export]]
Rcpp::List rcpp_decode_pl(Rcpp::StringVector encodedStrings){

  int encodedSize = encodedStrings.size();
	Rcpp::List resultLats(encodedSize);
	Rcpp::List resultLons(encodedSize);

  for(int i = 0; i < encodedSize; i++){

  	std::string encoded = Rcpp::as< std::string >(encodedStrings[i]);

  	Rcpp::List decoded = decode_polyline(encoded);

  	resultLats[i] = decoded["lat"];
  	resultLons[i] = decoded["lon"];
  }

  return Rcpp::List::create(_["lat"] = resultLats, _["lon"] = resultLons);
}


Rcpp::List decode_polyline(std::string encoded){

	int len = encoded.size();
	int index = 0;
	float lat = 0;
	float lng = 0;

	NumericVector pointsLat;
	NumericVector pointsLon;

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
	return Rcpp::List::create(_["lat"] = pointsLat, _["lon"] = pointsLon);
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
	float maxDistance = 0.0;
	float thisDistance;
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
	                             distanceTolerance, spdt::EARTH_RADIUS));

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
                               double tolerance, double earthRadius){

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

			if(distanceHaversine(lats[i], lons[i], lats[i + 1], lons[i + 1], tolerance, earthRadius) > distanceTolerance){
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




