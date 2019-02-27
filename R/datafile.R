#' return path of a file in the data directory
#' 
#' Returns the full here() path from a file in the data directory
#'
#' @param fname filename (without the path)
#'
#' @return
#' full path of file to data directory
#' 
#' @importFrom here here 
#' @export



datafile <- function(fname) {

    dcinfo <- getDatacubeConfig()$dcinfo
    f <- here::here(dcinfo$workdir,"data",fname)
    return(f)
}

