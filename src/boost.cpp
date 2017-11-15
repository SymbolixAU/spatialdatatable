#include <Rcpp.h>
using namespace Rcpp;

//#include <iostream>
//#include <iomanip>
//#include <sstream>
//#include <string>

#include "sdt.h"
// [[Rcpp::depends(BH)]]

// One include file from Boost
#include <boost/geometry.hpp>
#include <boost/geometry/geometries/point_xy.hpp>
#include <boost/geometry/geometries/polygon.hpp>

using namespace boost::geometry;

// [[Rcpp::export]]
void pointDistance(){
	model::d2::point_xy<int> p1(1, 1), p2(2, 2);
	std::cout << "Distance p1-p2 is: " << distance(p1, p2) << std::endl;
}

Rcpp::StringVector write_data(Rcpp::List sfc, int i, bool EWKB,
                int endian, const char *cls, const char *dim, double prec, int srid);

void add_int(std::ostringstream& os, unsigned int i) {
	const char *cp = (char *)&i;
	os.write((char*) cp, sizeof(int));
}

void add_byte(std::ostringstream& os, char c) {
	os.write((char*) &c, sizeof(char));
}

// [[Rcpp::export]]
void boostWkt(){
	// http://www.boost.org/doc/libs/1_65_0/libs/geometry/doc/html/geometry/reference/io/wkt/wkt.html
	namespace geom = boost::geometry;
	typedef geom::model::d2::point_xy<double> point_type;

	point_type point = geom::make<point_type>(3, 6);
	geom::model::polygon<point_type> polygon;
	geom::append(geom::exterior_ring(polygon), geom::make<point_type>(0, 0));
	geom::append(geom::exterior_ring(polygon), geom::make<point_type>(0, 4));
	geom::append(geom::exterior_ring(polygon), geom::make<point_type>(4, 4));
	geom::append(geom::exterior_ring(polygon), geom::make<point_type>(4, 0));
	geom::append(geom::exterior_ring(polygon), geom::make<point_type>(0, 0));

	std::cout << boost::geometry::wkt(point) << std::endl;
	std::cout << boost::geometry::wkt(polygon) << std::endl;
}

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


unsigned int make_type(const char *cls, const char *dim, bool EWKB = false, int *tp = NULL,
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
	else
		type = SF_Unknown; // a mix: GEOMETRY
	if (tp != NULL)
		*tp = type;
	Rcpp::Rcout << "type: " << type << std::endl;
	return type;
}

void write_multipolygon(Rcpp::List lst, bool EWKB = false,
                        int endian = 0, double prec = 0.0) {
	Rcpp::CharacterVector cl_attr = lst.attr("class");

	Rcpp::Rcout << "write_multipolygon() " << cl_attr << std::endl;

	const char *dim = cl_attr[0];

	Rcpp::Rcout << "dim attr: " << dim << std::endl;

	//add_int(os, lst.length());
	for (int i = 0; i < lst.length(); i++)
		write_data(lst, i, EWKB, endian, "POLYGON", dim, prec, 0);
}

Rcpp::String write_matrix( Rcpp::NumericMatrix mat) {

	Rcpp::Rcout << "write_matrix() " << std::endl;
	Rcpp::String encodedString;

	//	int nRow = mat.nrow();
	//	int nCols = mat.ncol();

	//Rcpp::Rcout << "rows: " << nRow << std::endl;
	//Rcpp::Rcout << "cols: " << nCols << std::endl;

	//	add_int(os, mat.nrow());
	//for (int i = 0; i < mat.nrow(); i++){
	//add_double(os, mat(i,j), prec);
	Rcpp::NumericVector lats = mat(_, 1);
	Rcpp::NumericVector lons = mat(_, 0);
	Rcpp::Rcout << lats << std::endl;
	int n = lats.size();
	encodedString = encode_polyline(lats, lons, n);

	//Rcpp::Rcout << encodedString << std::endl;
	//os.write(encodedString);

	return encodedString;

	//}
}

Rcpp::StringVector write_matrix_list(Rcpp::List lst) {

	Rcpp::Rcout << "write_matrix_list() " << std::endl;
	Rcpp::StringVector tempOutput;

	size_t len = lst.length();
	Rcpp::StringVector encoded(len);

	Rcpp::Rcout << "write_matrix_list size: " << len << std::endl;

	for (size_t i = 0; i < len; i++)
		encoded[i] = write_matrix(lst[i]);

	tempOutput = encoded[0];
	Rcpp::Rcout << "write_matrix_list encoded: " << tempOutput << std::endl;
	return encoded;
}

// write single simple feature object as (E)WKB to stream os
Rcpp::StringVector write_data(Rcpp::List sfc, int i = 0, bool EWKB = false,
                int endian = 0, const char *cls = NULL, const char *dim = NULL, double prec = 0.0,
                int srid = 0) {

	Rcpp::Rcout << "write_data() " << std::endl;

	Rcpp::StringVector encoded;

	int tp;
	unsigned int sf_type = make_type(cls, dim, EWKB, &tp, srid);

	Rcpp::Rcout << "write_data type: " << sf_type << std::endl;

	switch(tp) {
		case SF_LineString:
			encoded[i] = write_matrix(sfc[i]);
			break;
		case SF_Polygon:
			encoded[i] = write_matrix_list(sfc[i]);
			break;
		case SF_MultiPolygon:
			write_multipolygon(sfc[i], EWKB, endian, prec);
			break;
		default: {
			Rcpp::Rcout << "type is " << sf_type << "\n"; // #nocov
			Rcpp::stop("writing this sf type is not supported, please file an issue"); // #nocov
		}
	}

	Rcpp::Rcout << "return: write_data()" << std::endl;
//	Rcpp::StringVector temp = encoded[0];
//	Rcpp::Rcout << temp << std::endl;
	return encoded;

}

Rcpp::List get_dim_sfc(Rcpp::List sfc) {

	if (sfc.length() == 0)
		return Rcpp::List::create(
			Rcpp::Named("_cls") = Rcpp::CharacterVector::create("XY"),
			Rcpp::Named("_dim") = Rcpp::IntegerVector::create(2)
		);

	// we have data:
	Rcpp::CharacterVector cls = sfc.attr("class");
	unsigned int tp = make_type(cls[0], "", false, NULL, 0);
	if (tp == SF_Unknown) {
		cls = sfc.attr("classes");
		tp = make_type(cls[0], "", false, NULL, 0);
	}

	Rcpp::Rcout << "tp: " << tp << std::endl;

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
Rcpp::List encodeSFWKB(Rcpp::List sfc){

	double precision = sfc.attr("precision");
	Rcpp::CharacterVector cls_attr = sfc.attr("class");
	Rcpp::List sfc_dim = get_dim_sfc(sfc);
	Rcpp::CharacterVector dim = sfc_dim["_cls"];
	const char *cls = cls_attr[0], *dm = dim[0];

	Rcpp::List output(sfc.size()); // with raw vectors

	double s = sfc.size();
	Rcpp::Rcout << s << std::endl;

	for (int i = 0; i < sfc.size(); i++){
		Rcpp::checkUserInterrupt();
		output[i] = write_data(sfc, i, false, 0, cls, dm, precision, 0);
	}
	return output;
}


// read WKT and encode coordinates into polylne
// [[Rcpp::export]]
void encodeWKT(Rcpp::List sfc){

	namespace bg = boost::geometry;
	namespace bgm = bg::model;

	typedef double base_type;
	typedef bgm::d2::point_xy<base_type> point_type;
	typedef bgm::polygon<point_type> polygon_type;
	typedef bgm::multi_polygon<polygon_type> multipolygon_type;

	polygon_type pl;

	Rcpp::CharacterVector cl_attr = sfc.attr("class");
	Rcpp::Rcout << cl_attr << std::endl;
	Rcpp::Rcout << "sfc size: " << sfc.size() << std::endl;

	for (int i = 0; i < sfc.size(); i++) {
		Rcpp::List lst = sfc[i];
		Rcpp::Rcout << "sfc[i] size: " << lst.size() << std::endl;

		int n = lst.size();
		Rcpp::NumericVector x(n);

		for (int j = 0; j < lst.size(); j++) {
			//x[j] = lst[j];
			Rcpp::Rcout << j << std::endl;

			Rcpp::List lst2 = lst[j];
			Rcpp::Rcout << "lst2 size: " <<  lst2.size() << std::endl;
			// get the class!!!
			Rcpp::CharacterVector lst_attr = lst2.attr("class");
			Rcpp::Rcout << "lst2 attr: " << lst_attr << std::endl;

		}
	}
}

//bg::read_wkt(sfc, pl);

//	bg::read_wkt("POLYGON ((0 0, 0 15998.49, 12798.76 15998.49, 12798.76 0, 0 0), "
//                "(3921.294 177.8112, 9064.3339 177.8112, 9064.333 2951.2112, 3921.294 2951.2112, 3921.294 177.8112), "
//                "(9064.3340 177.8112, 12765.034 177.8112, 12765.034 5192.0872, 12743.139 5192.0872, 12743.139 6685.701, 11439.19 6685.701, 11439.19 5192.0872, 11438.834 5192.0872, 11438.834 2951.2112, 9064.334 2951.2112, 9064.334 177.8112), )", pl);


//std::string reason;
//std::cout << (bg::is_valid(pl, reason)?"valid ":"invalid ") << reason << std::endl;
//std::cout << bg::wkt(pl) << "\n";
