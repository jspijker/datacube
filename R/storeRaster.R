#' Store a raster into the datacube 
#'
#' This function stores a raster grid file as blob into the datacube
#'
#' @param gridfile filename of the raster grid file
#' @param blobname objectname of the blob
#' @param kv meta data key-value pairs
#' @param desc blob object description
#'
#' @return the meta data of the blob object
#'
#' This a wrapper function around \code{link{grid2tif}} and
#' \code{link{pgblobs::createBlob}}. It first converts the raster file
#' into a GeoTIFF file and then stores the GeoTIFF file into the
#' datacube. The GeoTIFF file is not removed from the data
#' directory
#'
#' please not that this function results in an error if the blob
#' object allready exists.
#' @export



storeRaster <- function(gridfile,blobname,kv,desc) {

    # create tif from grid
    tif <- grid2tif(gridfile)

    # create blob
    b <- createBlob(fname=tif,
		    name=blobname,
		    kv=kv,
		    description=desc)

    # return meta info
    invisible(b)

}



#' drname add
#' @export
grid2blob <- function(gridfile,blobname,keyval,desc,
                      blobpath=getOption("datacube.blobs")) {
    # legacy function
    warning("grid2blob is obsolete function,blobpath is ignored")
    storeRaster(gridfile,blobname,kv=keyval,desc)
}
