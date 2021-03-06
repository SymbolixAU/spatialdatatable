% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/DistanceCalculations.R
\name{dtAntipode}
\alias{dtAntipode}
\title{dt Antipode}
\usage{
dtAntipode(lat, lon)
}
\arguments{
\item{lat}{latitude coordinate}

\item{lon}{longitude coordinate}
}
\value{
a list of length 2, the first element being the latitude coordinates,
and the second element being the longitude coordinates
}
\description{
Calculates the antipodal coordiantes for a given pair of coordinates
}
\examples{
\dontrun{

 dt <- data.table(lat = c(-37,-36,-35),
                  lon = c(143,144,145))

 ## return just the antipodes
 dt[, dtAntipode(lat, lon)]

 ## return a new columns of antipodes
 dt[, c("AntLat", "AntLon") := dtAntipode(lat, lon)]

}

}
