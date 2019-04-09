#' converts a raster grid to GeoTIFF
#'
#' This function converts a raster grid file (actually, 2 files) into
#' a GeoTIFF file (a single file). The GeoTIFF file get's the same
#' file name as the raster file. If the GeoTIFF file exists, it will
#' be overwriten.
#'
#' @param gridfile filename of the raster grid file
#'
#' @return the file path of the GeoTIFF file
#'
#' @export


grid2tif <- function(gridfile) {

    # check proper arguments
    if(!is.character(gridfile)) {
        stop("gridfile is not character")
    }

    if(!file.exists(gridfile)) {
        stop(paste("gridfile",gridfile," not found"))
    }

    # determine path and filenames
    base <- basename(gridfile)
    fdir <- dirname(gridfile)

    tif <- sub(".grd",".tif",base)
    tif <- paste(fdir,tif,sep="/")

    cat("grid2tif:",gridfile,"->",tif,"\n")

    # read raster grid, write as geotiff
    f1 <- raster(gridfile)
    writeRaster(f1,tif,overwrite=TRUE,format="GTiff")

    return(tif)
}

