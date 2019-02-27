# utility functions

# print message
printmsg <- function(msg=repo(),x=MESSAGE) {

    cat("datacube loaded\n")
    cat(msg,"\n")
    cat(x,"\n")
}



# create DSN for postgresql connection
get_pgDSN <- function() {
    pginfo <- getDatacubeConfig()$pginfo

    DSN <- paste("PG:dbname='",pginfo$dbname,"' host='",pginfo$host,"' user='",pginfo$user,
                 "' password='",pginfo$passwd,"'",sep="")
    return(DSN)


}

