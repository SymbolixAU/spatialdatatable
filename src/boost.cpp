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


//Rcpp::Date getIMMDate(int mon, int year) {
//	// compute third Wednesday of given month / year
//	date d = nth_day_of_the_week_in_month(nth_day_of_the_week_in_month::third,
//                                      Wednesday, mon).get_date(year);
//	date::ymd_type ymd = d.year_month_day();
//	return Rcpp::wrap(Rcpp::Date(ymd.year, ymd.month, ymd.day));
//}
