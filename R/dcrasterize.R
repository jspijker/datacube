#' rasterize vector data using fasterize
#' 
#' Rasterize vector data using fasterize (fast rasterize) function. It
#' creates a raster grid file and seperate attribute table stored in a
#' .rds file.
#' This functions requires a datacube reference (pixid) grid
#'
#' @param obj spatial vector object
#' @param layername name of rasterlayer
#' @param attribute name of attribute to rasterize
#' @param refraster reference raster
#'
#' @return
#' this function creates three files in the data directory, two raster
#' files (grd and gri) and a rds file with the attribute table. This
#' function returns a list with the filenames.
#' 
#' @importFrom fasterize fasterize
#' @export

dcrasterize <- function(obj,layername,attribute,refraster) {


    cat("start dcrasterize\n")

    gridfile <- datafile(paste(layername,"grd",sep="."))
    attrfile <- datafile(paste(layername,"_attr",".rds",sep=""))

    cat("using files:\n",gridfile,"\n",attrfile,"\n")

    r <- fasterize::fasterize(obj,refraster,field=attribute)
    writeRaster(r,gridfile,overwrite=TRUE)

    attrs <- obj %>% st_set_geometry(NULL)

    names(attrs) <- tolower(names(attrs))
    saveRDS(attrs,attrfile)
    return(list(gridfile=gridfile,attrfile=attrfile))

}

