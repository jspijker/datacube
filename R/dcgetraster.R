#' Get a raster from the datacube 
#'
#' This function loads a raster grid file from the datacube and stores
#' it into the data directory
#'
#' @param obj name of datacube object
#' @param update if TRUE, always get raster even if it allready exists
#'
#' @return the meta data of the blob object
#'
#' This a wrapper function around \code{link{pgblobs::getBlob}}.  
#' It assumes that rasters in the datacube are stored as GeoTIFF
#' files. This function gets the GeoTiff file from the datacube and
#' converts it into a normal raster file.
#'
#' This functions checks if the raster file allready exists, if it
#' exists is does not load the file from the datacube since this is
#' time consuming. If the user wants to update the file, use argument
#' `update=TRUE`
#'
#' The GeoTiff will be deleted after writing the raster file.
#' @export

dcgetraster <- function(obj,update=FALSE) {

    if(!is.character(obj)) {
        stop("dcgetraster: obj is not character")
    }

    if(!objectExists(obj)) {
        stop("dcgetraster: obj does not exists")
    }

    if(!is.logical(update)) {
        stop("dcgetraster: update is not logical")
    }


    b <- getObj(obj)
    rast <- b$fname
    rast <- sub(".tif",".grd",rast)
    fname.rast <- datafile(rast)

    if(update && file.exists(fname.rast)) {
        cat("getRaster:updating: removing existing file",fname.rast,"\n")
        file.remove(extension(fname.rast,"gri"))
        file.remove(fname.rast)
    } 

    if(!file.exists(fname.rast)) {
        cat("getRaster: try to get raster:",obj,"\n")

        getBlob(obj,path="./data/")
        #fgrid <- datafile(sub(".tif",".grd",base))
#        fgrid <- paste(path,fgrid,sep="/")
        tif <- datafile(b$fname)

        cat("dcgetraster:",tif,"->",fname.rast,"\n")

        f1 <- raster(tif)
        writeRaster(f1,fname.rast,overwrite=TRUE)
        file.remove(tif)
    }
    return(rast)
}


