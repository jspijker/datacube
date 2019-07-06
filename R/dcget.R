#' Get blob object from datacube
#' 
#' Gets a blob object from the datacube. This function checks if the
#' blob already exists and, if so, needs to be updated. Also this
#' function creates an audit object for recording the data lineage
#'
#' @param obj name of blob object
#' @param update force update
#' @param verbose show extra verbose output
#'
#' @return
#' This function returns the pgobjects blob object. If the object is
#' updated, i.e an updated file is copied from the blobpath, than an
#' audit object is created which records the data lineage. The
#' returned updated object includes this audit object.
#' 
#' @export


dcget <- function(obj,update=FALSE,verbose=FALSE) {

    if(verbose) cat("dcget:\n")

    b <- getObj(obj)
    fname <- datafile(b$fname)
    if (verbose) cat("fname:",fname,"\n")

    if(file.exists(fname)) {
        if (verbose) cat("file exists\n")
        md5.fname <- getmd5(fname)
        if(b$md5!=md5.fname) {
            if (verbose) cat("md5 differs\n")
            update <- TRUE
        } else {
            if (verbose) cat("equal md5\n")
        }
        if(verbose) cat("md5s:\nblob:",b$md5,"\nfile",md5.fname,"\n")

    } else {
        update <- TRUE
        if (verbose) cat("file does not exist\n")
    }

    if(update) {

        if (verbose) cat("file update\n")
        # maak audit object
        dcconfig <- getDatacubeConfig()
        dckeyval <- getkeyval()

        parentMeta <- getKeyvalObj(obj)
        parentKv <- parentMeta$value
        names(parentKv) <- parentMeta$key
        parentKv <- as.list(parentKv)

        audit <- list(script=getDatacubeConfig(),
                      parent=parentKv,
                      object=obj)
        auditObjname <- uuid::UUIDgenerate()
        if (verbose) cat("audit object:",auditObjname,"\n")

        kv <- list( script=dckeyval$script,
                   repo=dckeyval$repo,
                   type="audit",
                   audit=objname,
                   time=as.character(lubridate::now()))

        if (verbose) cat("storing audit object\n")
        storeObj(name=auditObjname,
                 obj=audit)
        for (i in names(kv)) {
            storeKeyval(obj=auditObjname,key=i,val=kv[[i]],overwrite=TRUE)
        }

        if (verbose) cat("getBlob:",obj,"\n")
        b<-getBlob(blob=obj,path="./data/")
        b <- append(b,list(audit=audit,auditobj=auditObjname))
    }
    return(b)
}


