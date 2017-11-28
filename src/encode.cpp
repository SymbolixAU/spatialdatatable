#include <Rcpp.h>
using namespace Rcpp;
#include "sdt.h"

// [[Rcpp::depends(BH)]]

#include <boost/algorithm/string.hpp>

void write_data(std::ostringstream& os, Rcpp::List sfc,
                const char *cls, int srid);

void add_int(std::ostringstream& os, unsigned int i) {
	const char *cp = (char *)&i;
	os.write((char*) cp, sizeof(int));
}

void add_byte(std::ostringstream& os, char c) {
	os.write((char*) &c, sizeof(char));
}

void write_matrix_list(std::ostringstream& os, Rcpp::List lst);

// http://www.boost.org/doc/libs/1_65_0/libs/geometry/doc/html/geometry/reference/io/wkt/wkt.html


// TODO:
// encoded polyline to model::polygon
// - model::polygon<model::d2::point_xy<double> > poly;
// - http://www.boost.org/doc/libs/1_65_0/libs/geometry/doc/html/geometry/quickstart.html

// how does boost handle MULTIPOLYGONS and MULTILINESTRINGS? and polygons with holes?

// an example of it in use
// - https://github.com/mapbox/spatial-algorithms/blob/master/examples/hello-spatial-algorithms.cpp#L8

// resources
// - https://stackoverflow.com/questions/19959723/boost-polygon-serialization
// - https://stackoverflow.com/questions/21438732/boost-polygon-serialization-ring


// - WKT
// - http://www.boost.org/doc/libs/1_60_0/boost/geometry/io/wkt/read.hpp


unsigned int make_type(const char *cls, int *tp = NULL,
                       int srid = 0) {
	int type = 0;
	if (strstr(cls, "sfc_") == cls)
		cls += 4;
	if (strcmp(cls, "POINT") == 0)
		type = SF_Point;
	else if (strcmp(cls, "LINESTRING") == 0)
		type = SF_LineString;
	else if (strcmp(cls, "POLYGON") == 0)
		type = SF_Polygon;
	else if (strcmp(cls, "MULTILINESTRING") == 0)
		type = SF_MultiLineString;
	else if (strcmp(cls, "MULTIPOLYGON") == 0)
		type = SF_MultiPolygon;
	else if (strcmp(cls, "GEOMETRY") == 0)
		type = SF_Geometry;
//	else if (strcmp(cls, "GEOMETRYCOLLECTION") == 0)
//		type = SF_GeometryCollection;
	else
		type = SF_Unknown; // a mix: GEOMETRY
	if (tp != NULL)
		*tp = type;
//	Rcpp::Rcout << "type: " << type << std::endl;
	return type;
}

void write_multipolygon(std::ostringstream& os, Rcpp::List lst) {

	//Rcpp::CharacterVector cl_attr = lst.attr("class");

	for (int i = 0; i < lst.length(); i++){
		//write_data(os, lst, i, "POLYGON", 0);
		write_matrix_list(os, lst[i]);

	}
}

void write_geometrycollection(std::ostringstream& os, Rcpp::List lst) {

	Rcpp::Function Rclass("class");
	for (int i = 0; i < lst.length(); i++) {
		Rcpp::CharacterVector cl_attr = lst[i];
		//Rcpp::Rcout << cl_attr << std::endl;
		//const char *cls = cl_attr[1], *dim = cl_attr[0];
		//write_data(os, lst, i, EWKB, endian, cls, dim, prec, 0);
	}
}

void addToStream(std::ostringstream& os, Rcpp::String encodedString) {
	std::string strng = encodedString;
	os << strng << ' ';
}


void encode_vector( std::ostringstream& os, Rcpp::List vec ) {

	int n = vec.size() / 2;
	Rcpp::String encodedString;

	Rcpp::NumericVector lats(n);
	Rcpp::NumericVector lons(n);

	for (int i = 0; i < n; i++){
		lons[i] = vec[i * 2];
		lats[i] = vec[(i * 2) + 1];
	}
	encodedString = encode_polyline(lats, lons, n);
	addToStream(os, encodedString);
}

void encode_vectors( std::ostringstream& os, Rcpp::List sfc ){

	int n = sfc.size();
	for (int i = 0; i < n; i++) {
		encode_vector(os, sfc[i]);
	}
}

void encode_matrix(std::ostringstream& os, Rcpp::NumericMatrix mat ) {

	Rcpp::String encodedString;

	Rcpp::NumericVector lats = mat(_, 1);
	Rcpp::NumericVector lons = mat(_, 0);

	int n = lats.size();
	encodedString = encode_polyline(lats, lons, n);

	addToStream(os, encodedString);
}

void write_matrix_list(std::ostringstream& os, Rcpp::List lst) {

	size_t len = lst.length();

	//TODO:
	// is this ever greater than 1?
	for (size_t j = 0; j < len; j++){
		Rcpp::NumericVector lats = lst[j];
		encode_matrix(os, lst[j]);
	}
}

void write_geometry(std::ostringstream& os, Rcpp::List lst) {
	//size_t len = lst.length();

	Rcpp::Rcout << "write_geometry() " << std::endl;
	//for (size_t j = 0; j < len; j++) {

		Rcpp::List sfcList = lst;

		if ( Rf_isNull(sfcList) ) {
			Rcpp::Rcout << "sfcList IS NULL" << std::endl;
		} else {
			Rcpp::Rcout << "sfcList NOT NULL" << std::endl;
			//Rcpp::CharacterVector cls_attr = sfcList.attr("class");

			if (!Rf_isNull(sfcList.attr("class")) ){
				Rcpp::Rcout << "cls_attr NOT NULL" << std::endl;
				Rcpp::CharacterVector cls_attr = sfcList.attr("class");
				Rcpp::Rcout << cls_attr << std::endl;
				const char *cls = cls_attr[1];
				write_data(os, lst, cls, 0);
			} else {
				Rcpp::Rcout << "cls_attr IS NULL" << std::endl;

				// TODO: why is cls NULL?
				write_data(os, lst, "LINESTRING", 0);
			}
		}


//		Rcpp::Rcout << cls << std::endl;
//		write_data(os, lst, cls, 0);
	//}
}


void write_data(std::ostringstream& os, Rcpp::List sfc,
                const char *cls = NULL, int srid = 0) {

	int tp;
	unsigned int sf_type = make_type(cls, &tp, srid);

	Rcpp::Rcout << "write_data()" << std::endl;
	Rcpp::Rcout << "tp: " << tp << std::endl;

	switch(tp) {
		case SF_LineString:
			encode_vector(os, sfc);
			break;
		case SF_MultiLineString:
			encode_vectors(os, sfc);
			break;
		case SF_Polygon:
			write_matrix_list(os, sfc);
			break;
		case SF_MultiPolygon:
			write_multipolygon(os, sfc);
			break;
		case SF_Geometry:
			write_geometry(os, sfc);
			break;
//		case SF_GeometryCollection:
//			write_geometrycollection(os, sfc[i]);
//			break;
		default: {
			Rcpp::Rcout << "type is " << sf_type << "\n"; // #nocov
			Rcpp::stop("writing this sf type is not supported, please file an issue"); // #nocov
		}
	}
}

Rcpp::List get_dim_sfc(Rcpp::List sfc) {

	if (sfc.length() == 0)
		return Rcpp::List::create(
			Rcpp::Named("_cls") = Rcpp::CharacterVector::create("XY"),
			Rcpp::Named("_dim") = Rcpp::IntegerVector::create(2)
		);

	// we have data:
	Rcpp::CharacterVector cls = sfc.attr("class");

	unsigned int tp = make_type(cls[0], NULL, 0);

	if (tp == SF_Unknown) {
		cls = sfc.attr("classes");
		tp = make_type(cls[0], NULL, 0);
	}

	switch (tp) {
	case SF_Unknown: { // further check:
		Rcpp::stop("impossible classs in get_dim_sfc()"); // #nocov
	} break;
	case SF_Point: { // numeric:
		Rcpp::NumericVector v = sfc[0];
		cls = v.attr("class");
	} break;
	case SF_LineString:  // matrix:
	case SF_MultiPoint:
	case SF_CircularString:
	case SF_Curve: {
		Rcpp::NumericMatrix m = sfc[0];
		cls = m.attr("class");
	} break;
	case SF_Polygon: // list:
	case SF_MultiLineString:
	case SF_MultiPolygon:
	case SF_Geometry:
	case SF_GeometryCollection:
	case SF_CompoundCurve:
	case SF_CurvePolygon:
	case SF_MultiCurve:
	case SF_MultiSurface:
	case SF_Surface:
	case SF_PolyhedralSurface:
	case SF_TIN:
	case SF_Triangle: {
		Rcpp::List l = sfc[0];
		cls = l.attr("class");
	} break;
	}

	return Rcpp::List::create(
		Rcpp::Named("_cls") = cls,
		Rcpp::Named("_dim") = strstr(cls[0], "Z") != NULL ?
	Rcpp::IntegerVector::create(3) :
		Rcpp::IntegerVector::create(2));
}

// [[Rcpp::export]]
Rcpp::List encodeGeometry(Rcpp::List sfc){

	Rcpp::CharacterVector cls_attr = sfc.attr("class");
	//Rcpp::Rcout << "class: " << cls_attr << std::endl;

	Rcpp::List sfc_dim = get_dim_sfc(sfc);

	Rcpp::CharacterVector dim = sfc_dim["_cls"];
	const char *cls = cls_attr[0];

	Rcpp::Rcout << "cls: " <<  cls_attr << std::endl;
	Rcpp::Rcout << "dim: " << dim << std::endl;

	Rcpp::List output(sfc.size());

	for (int i = 0; i < sfc.size(); i++){

		Rcpp::Rcout << "i: " << i << std::endl;

		std::ostringstream os;
		Rcpp::checkUserInterrupt();

		Rcpp::List l = sfc[i];
		Rcpp::CharacterVector cv = l.attr("class");
		Rcpp::Rcout << "loop i: cls: " << cv << std::endl;

		write_data(os, sfc[i], cls, 0);

		std::string str = os.str();
		std::vector<std::string> strs;
		boost::split(strs, str, boost::is_any_of("\t "));

		strs.erase(strs.end() - 1);
		output[i] = strs;
	}

	return output;
}

