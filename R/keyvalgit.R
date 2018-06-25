#' Set key-value pairs for git
#'
#' Set key-value pairs for git meta information
#'
#' @export

keyvalgit <- function(){
    # creates a key/value list based on gitinfo(). This key/value list
    # can be used for pgobjects

    ginfo <- gitinfo()
    # ginfo.list <- list(git.id=ginfo$id,git.status=ginfo$status,
    #        git.fetch=ginfo$remote$origin$fetch) 
    ginfo.list <- list(git.id=ginfo$id,git.status=ginfo$status)
    if(ginfo$remote!="none") {
        ginfo.list <- append(ginfo.list,
                             list(git.fetch= ginfo$remote$origin$fetch))
    } else {
        ginfo.list <- append(ginfo.list,
                             list(git.fetch= "none"))
    }

    return(ginfo.list)
}




