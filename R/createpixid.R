#' Create pixel id grid
#' 
#' Creates a pixel id grid, a grid with consecutive cell numbers.
#' 
#' This functions requires a datacube reference (pixid) grid
#'
#' @param xmin minimum x coordinate
#' @param xmax maximum x coordinate
#' @param ymin minimum y coordinate
#' @param ymax maximum y coordinate
#' @param resolution resolution of grid 
#'
#' @return
#' A raster grid with extent (xmin,xmax,ymin,ymax) and given
#' resolution. All values in meters. The 'Amersfoort' projection is
#' used as coordinate reference system.
#' 
#' @importFrom raster raster
#' @export

createPixid <- function(xmin=0,xmax=280000,
                        ymin=300000,ymax=625000,
                        resolution=25) {

    xcells=(xmax-xmin)/resolution
    ycells=(ymax-ymin)/resolution

    x <- raster::raster(xmn=xmin,
                xmx=xmax,
                ymn=ymin,
                ymx=ymax,
                nrows=ycells,
                ncols=xcells,
                crs=CRS("+init=epsg:28992")
                )


    x[] <- 1:ncell(x)
    return(x)
}

