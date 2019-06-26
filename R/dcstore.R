#' Stores a single file as blob object in the datacube
#' 
#' This function stores a single file as blob object in the datacube.
#' Meta data is given as a list with key,value pairs
#'
#' @param filename filename of file to store
#' @param objname name of the object to store
#' @param kv list of key, pairs
#'
#' @return
#' This function returns the pgobjects blob object, which includes the
#' object meta data
#'
#' @export


dcstore <- function(filename,objname,kv) {

    if(!file.exists(filename)) {
        stop(paste("file",filename,"does not exists"))
    }

    if(!is.list(kv)) {
        stop("kv is not a list")
    }
        
    kv.proj <- getkeyval()
    if(objectExists(objname)) {
    
        b <- getObj(objname)
        kv1 <- c(kv.proj$repo,kv.proj$project,kv.proj$script)
        kv2 <- c(b$kv$repo,b$kv$project,b$kv$script)
        if(!any(kv1==kv2)){
            stop("overwriting wrong object")
        }
        deleteBlob(objname)
    }


    # create blob
    b <- createBlob(fname=filename,
               name=objname,
               kv=append(getkeyval(),kv)
               )
    return(b)

}



