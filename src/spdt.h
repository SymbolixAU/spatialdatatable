#include <Rcpp.h>
using namespace Rcpp;

#ifndef SPDT_H
#define SPDT_H

namespace spdt {

  struct GPS{
  	double lat;
  	double lon;
  };

  //const double EARTH_RADIUS = 6378137.0
  const double EARTH_RADIUS = 6371009;
  const double RADIAN = 57.2957795131;  // 180 / PI
  const double DEGREE = 0.01745329251;  // PI / 180

}

#endif

  //const double DISTANCE_TOLERANCE = 1000000000.0;

  void vectorCheck(NumericVector v1, NumericVector v2);

  /**
   * To Radians
   *
   * Converts degrees to radians
   *
   * @param deg
   *     degree to convert to radians
   */
  double toRadians(double deg);

  /**
   * To Degrees
   *
   * Converts radians to degrees
   *
   * @param rad
   *    radian to convert to degrees
   */
  double toDegrees(double rad);

  double normaliseLonDeg(double deg);

  double distanceHaversine(double latf, double lonf, double latt, double lont,
                           double tolerance, double earthRadius);

  double distanceCosine(double latf, double lonf, double latt, double lont,
                        double earthRadius);


  double distanceEuclidean(double latf, double lonf, double latt, double lont);

  double bearingCalc(double latf, double lonf, double latt, double lont,
                     bool compassBearing);

  double crossTrack(double distance, double bearing1, double bearing2, double earthRadius);


  double alongTrack(double distance, double xtrack, double earthRadius);

  /**
   * Is Left
   *
   * Tests if a point is Left|On|Right of an infinite line
   * @param p0x x coordinate of the first point in the line
   * @param p0y y coordinate of the first point in the line
   * @param p1x x coordinate of the last point in the line
   * @param p1y y coordinate o fthe last point in the line
   * @param p2x x coordinate of the point
   * @param p2y y coordinate of the point
   *
   * @return double
   * > 0 : P2 is left of the line through P0, P1
   * = 0 : P2 is on the line
   * < 0 : P2 is right of the line through P0, P1
   *
   */
  double isLeft(double p0x, double p0y, double p1x, double p1y, double p2x, double p2y);

  /**
   * Is Polygon Closed
   *
   * Checks if the last coordinates equal the first coordinates
   *
   * @param start.x
   * @param start.y
   * @param end.x
   * @param end.y
   */
  bool isPolygonClosed(double startX, double endX, double startY, double endY);

  /**
   * Close Polygon
   *
   * Sets the last entry in a vector to be the same as the first
   *
   * @param polyVector numeric vector
   * @return numeric vector
   */
  Rcpp::NumericVector ClosePolygon(Rcpp::NumericVector polyVector);

  double rcppDist2gc(double latFrom, double lonFrom, double latTo, double lonTo,
                     double pointLat, double pointLon, double tolerance, double earthRadius);

  DataFrame decode_polyline(std::string encoded);

  Rcpp::String EncodeNumber(int num);

  Rcpp::String EncodeSignedNumber(int num);

  Rcpp::String encode_polyline(Rcpp::NumericVector latitude,
                               Rcpp::NumericVector longitude,
                               int num_coords);

  double windingNumber(double pointX, double pointY, NumericVector vectorX, NumericVector vectorY);


