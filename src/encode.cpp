#include <Rcpp.h>
using namespace Rcpp;
#include "sdt.h"

// [[Rcpp::depends(BH)]]

#include <boost/algorithm/string.hpp>

template <int RTYPE>
Rcpp::CharacterVector sfClass(Vector<RTYPE> v) {
	return v.attr("class");
}

Rcpp::CharacterVector getSfClass(SEXP sf) {

	switch( TYPEOF(sf) ) {
	case REALSXP: return sfClass<REALSXP>(sf);
	case VECSXP: return sfClass<VECSXP>(sf);
	default: Rcpp::stop("unknown sf type");
	}
	return "";
}

void write_data(std::ostringstream& os, SEXP sfc,
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

	for (int i = 0; i < lst.length(); i++){
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

void addToStream(std::ostringstream& os, Rcpp::String encodedString ) {
	Rcpp::Rcout << "add stream:" << std::endl;
	std::string strng = encodedString;
	os << strng << ' ';
}

void encode_vector( std::ostringstream& os, Rcpp::List vec ) {

	Rcpp::Rcout << "encoding vector" << std::endl;

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

	Rcpp::Rcout << "encoding matrix" << std::endl;
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

void write_geometry(std::ostringstream& os, SEXP s) {

	Rcpp::CharacterVector cls_attr = getSfClass(s);
	Rcpp::Rcout << "geometry cls_attr: " << cls_attr << std::endl;

	write_data(os, s, cls_attr[1], 0);

}


void write_data(std::ostringstream& os, SEXP sfc,
                const char *cls = NULL, int srid = 0) {

	int tp;
	unsigned int sf_type = make_type(cls, &tp, srid);

//	Rcpp::Rcout << "write_data()" << std::endl;
//	Rcpp::Rcout << "tp: " << tp << std::endl;

	switch(tp) {
	 	case SF_Point:
		 //encode_point(os, sfc);
		 encode_vector(os, sfc);
	 		break;
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



// [[Rcpp::export]]
Rcpp::List encodeGeometry(Rcpp::List sfc){

	Rcpp::CharacterVector cls_attr = sfc.attr("class");
	//Rcpp::Rcout << "class: " << cls_attr << std::endl;

//	Rcpp::List sfc_dim = get_dim_sfc(sfc);

//	Rcpp::CharacterVector dim = sfc_dim["_cls"];
	//const char *cls = cls_attr[0];

//	Rcpp::Rcout << "cls: " <<  cls_attr << std::endl;
//	Rcpp::Rcout << "dim: " << dim << std::endl;

	Rcpp::List output(sfc.size());

	for (int i = 0; i < sfc.size(); i++){

		//Rcpp::Rcout << "i: " << i << std::endl;

		std::ostringstream os;
		Rcpp::checkUserInterrupt();

		//Rcpp::List l = sfc[i];
		//Rcpp::CharacterVector cv = l.attr("class");
		//Rcpp::CharacterVector cv = getSfClass(sfc[i]);
		//Rcpp::Rcout << "loop i: cls: " << cv << std::endl;

		write_data(os, sfc[i], cls_attr[0], 0);

		std::string str = os.str();
		std::vector<std::string> strs;
		boost::split(strs, str, boost::is_any_of("\t "));

		strs.erase(strs.end() - 1);
		output[i] = strs;
	}

	return output;
}

