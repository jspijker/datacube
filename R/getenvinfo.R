#' get R environment info
#'
#' get R environment info 
#'
#' @export

getenvinfo <- function() {
    x <- Sys.info()

    if(x[["sysname"]]=="Linux") {
	isLinux=TRUE
    } else {
	isLinux=FALSE
    }

    isRStudio <- ifelse(.Platform$GUI=="RStudio",TRUE,FALSE)

    osenv <- list(user=x[["user"]],
		  os=x[["sysname"]],
		  machine=x[["nodename"]],
		  isLinux=isLinux,
		  isRStudio=isRStudio,
		  isGit=isGit()
		  )
    return(osenv)
}

getOSinfo <- function() {
    getenvinfo()
}

