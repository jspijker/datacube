#' Import datacube dataset from external file path
#' 
#' This function imports a datacube data set, i.e. a single file with
#' data and the ini file with meta data, from a location on disk. This
#' function is a wrapper around the pgblobs::blobImport function.
#'
#' @param importfile full path of the file to import
#' @param overwrite Should existing blobs be overwritten
#'
#' Please note that the importBLob function overwrites existing files in the
#' data directory
#'
#' @return
#' a pgobjects blob object
#' 
#' @export

dcimport <- function(importfile,overwrite=FALSE) {

    name <- importBlob(importfile,overwrite)
    return(name)

}
