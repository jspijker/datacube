#' Write a spatial vector object to postgis
#'
#' Write a spatial vector object to the datacube postgis tables
#' 
#' @param obj spatial vector object
#' @param layername name of layer
#' @param schema database schema were to create the table
#'
#' @return does not return anything
#'
#' @importFrom sf st_write
#'
#'


write_postgis <- function(obj,layername,schema="gis") {

    pgDSN <- get_pgDSN()
    sf::st_write(obj,dsn=pgDSN,
             layer=layername,
             layer_options=c("OVERWRITE=true", 
                            paste("SCHEMA=",schema,sep=""),
                                 "GEOMETRY_NAME=geom"))
             
}

