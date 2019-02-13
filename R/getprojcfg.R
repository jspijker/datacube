#' get project config
#'
#' get project config
#'
#' @param dir project directory
#' @param script filename of R script
#' @param setdir if TRUE, change workingdirectory to project dir
#'
#' @export

getprojcfg <- function(dir, script, setdir=TRUE) {

    warning("datacube::getprojcfg function is depreciated")

    osinfo <- getenvinfo()
    if(!osinfo$isGit) {
        stop("this is not a git repository")
    }

    git <- gitinfo()
 
    script.repo <- git$toplevel
    script.path <-  paste(script.repo,dir,script,sep="/")
    if(!file.exists(script.path)) {
        stop(paste("file",script.path,"does not exist"))
    }

    curwd <- getwd()

    script.file <- basename(script.path)
    script.dir <- dirname(script.path)
    script.project <- basename(dir)


    # set working directory
    if(setdir) {
        cat("changing working directory to:",script.dir,"\n")
        setwd(script.dir)
    }

    scriptdir <- list(file=script.file,dir=script.dir,
		      project=script.project,path=script.path,
		      repo=script.repo,git=git)

    options(prompt=paste(basename(getwd()),"> "))
    return(scriptdir)

}
