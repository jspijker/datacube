% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dcrasterize.R
\name{dcrasterize}
\alias{dcrasterize}
\title{rasterize vector data using fasterize}
\usage{
dcrasterize(obj, layername, attribute, refraster)
}
\arguments{
\item{obj}{spatial vector object}

\item{layername}{name of rasterlayer}

\item{attribute}{name of attribute to rasterize}

\item{refraster}{reference raster}
}
\value{
this function creates three files in the data directory, two raster
files (grd and gri) and a rds file with the attribute table. This
function returns a list with the filenames.
}
\description{
Rasterize vector data using fasterize (fast rasterize) function. It
creates a raster grid file and seperate attribute table stored in a
.rds file.
This functions requires a datacube reference (pixid) grid
}
