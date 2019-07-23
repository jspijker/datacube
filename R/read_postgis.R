#' Read a spatial vector object from postgis
#'
#' Write a spatial vector object to the datacube postgis tables
#' 
#' @param layername name of layer
#'
#' @return returns sf geo object
#'
#' @importFrom sf st_read
#'
#' @export

read_postgis  <- function(layername) {
    sf::st_read(get_pgDSN(),paste("gis",layername,sep="."))
}
