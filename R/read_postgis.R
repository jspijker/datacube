#' Read a spatial vector object from postgis
#'
#' Read a spatial vector object from the datacube postgis tables
#' 
#' @param layername name of layer
#'
#' @return a sf object with the postgis layer
#'
#' @importFrom sf st_read
#'
#' @export

read_postgis  <- function(layername) {
    sf::st_read(get_pgDSN(),paste("gis",layername,sep="."))
}

