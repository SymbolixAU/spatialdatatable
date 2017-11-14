#include <Rcpp.h>
using namespace Rcpp;

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
		}
		

	}


	//bg::read_wkt(sfc, pl);

//	bg::read_wkt("POLYGON ((0 0, 0 15998.49, 12798.76 15998.49, 12798.76 0, 0 0), "
//                "(3921.294 177.8112, 9064.3339 177.8112, 9064.333 2951.2112, 3921.294 2951.2112, 3921.294 177.8112), "
//                "(9064.3340 177.8112, 12765.034 177.8112, 12765.034 5192.0872, 12743.139 5192.0872, 12743.139 6685.701, 11439.19 6685.701, 11439.19 5192.0872, 11438.834 5192.0872, 11438.834 2951.2112, 9064.334 2951.2112, 9064.334 177.8112), )", pl);


	//std::string reason;
	//std::cout << (bg::is_valid(pl, reason)?"valid ":"invalid ") << reason << std::endl;
	//std::cout << bg::wkt(pl) << "\n";

}

