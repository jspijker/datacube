#' Get a raster from the datacube 
#'
#' This function loads a raster grid file from the datacube and stores
#' it into the data directory
#'
#' @param obj name of datacube object
#' @param path path to store grid file
#' @param update if TRUE, always get raster even if it allready exists
#'
#' @return the meta data of the blob object
#'
#' This a wrapper function around \code{link{pgblobs::getBlob}}.  
#' It assumes that rasters in the datacube are stored as GeoTIFF
#' files. This function gets the GeoTiff file from the datacube and
#' converts it into a normal raster file. This function also assumes
#' that the object name is the same as the basename of the raster
#' file without extention.
#'
#' This functions checks if the raster file allready exists, if it
#' exists is does not load the file from the datacube since this is
#' time consuming. If the user wants to update the file, use argument
#' `update=TRUE`
#'
#' The GeoTiff will be deleted after writing the raster file.
#' @export

getRaster <- function(obj,path="./data/",update=FALSE) {
    fname.grd <- paste(obj,"grd",sep=".")
    fname.rast <- paste(path,fname.grd,sep="/")

    if(update && file.exists(fname.rast)) {
        cat("getRaster:updating: removing existing file",fname.rast,"\n")
        file.remove(extension(fname.rast,"gri"))
        file.remove(fname.rast)
    } 

    if(!file.exists(fname.rast)) {
        cat("getRaster: try to get file:",fname.rast,"\n")

        b <- getBlob(obj,path=path)

        base <- basename(b$fname)

        fgrid <- sub(".tif",".grd",base)
        fgrid <- paste(path,fgrid,sep="/")
        tif <- paste(path,base,sep="/")

        cat("getRaster:",base,"->",fgrid,"\n")

        f1 <- raster(tif)
        writeRaster(f1,fgrid,overwrite=TRUE)
        file.remove(tif)
    }
    return(fname.rast)
}


