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



//Rcpp::Date getIMMDate(int mon, int year) {
//	// compute third Wednesday of given month / year
//	date d = nth_day_of_the_week_in_month(nth_day_of_the_week_in_month::third,
//                                      Wednesday, mon).get_date(year);
//	date::ymd_type ymd = d.year_month_day();
//	return Rcpp::wrap(Rcpp::Date(ymd.year, ymd.month, ymd.day));
//}
