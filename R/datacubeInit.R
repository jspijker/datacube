#' Initialization of the Datacube
#'
#' When the datacube is initialized it collects information about the
#' running environment (e.g. OS, user) and the used git repository.
#' Als a database connections is setup based on the information in the
#' `.R.options` file.
#' @param script the name of the running script in which the function is called, this script must exists
#' @param workdir the name of the project directory within the repository, this will be the R working directory
#' @param database the name of the database to connect to, database credentials must exists in the optionsfiles
#' @param optionsfile name of the optionsfile
#' @param setdir if true the a setwd() is used to set the working directory
#' 
#' @return this functions does not return anything
#'
#' Calling this function also creates a data directory in the working
#' directory when it not exists
#'
#' @importFrom pgobjects PgObjectsInit
#' @export


datacubeInit <- function(script,workdir,database="datacube",
                         optionsfile="~/.R.options",setdir=TRUE) {

    osinfo <- getenvinfo()
    if(!osinfo$isGit) {
        stop("this is not a git repository")
    }

    dcinfo <- list(script=script,workdir=workdir)
    dcinfo$OS <- getOSinfo()
    dcinfo$git <- gitInfo()
    assign("dcinfo",dcinfo,env=.DatacubeConfig)

    script.path <-  paste(dcinfo$git$root,dcinfo$workdir,script,sep="/")
    if(!file.exists(script.path)) {
        stop(paste("file",script.path,"does not exist"))
    }

    keyvalProject <- setprojkeyval()

    script.dir <-  paste(dcinfo$git$root,dcinfo$workdir,sep="/")
    if(setdir) {
        cat("changing working directory to:",script.dir,"\n")
        setwd(script.dir)

        # check if data.dir exists
        if(!dir.exists("./data/")) {
            cat("Creating data directory\n")
            dir.create("./data/")
        }

    }


    #### read options file
    readOptions(optionsfile)

    pginfo <- list(dbname=getOption(paste(database,"dbname",sep=".")),
                  user=getOption(paste(database,"user",sep=".")),
                  passwd=getOption(paste(database,"password",sep=".")),
                  host=getOption(paste(database,"host",sep=".")),
                  schema=getOption(paste(database,"schema",sep=".")),
                  blobs=getOption(paste(database,"blobs",sep="."))
                  )

    assign("pginfo",pginfo,env=.DatacubeConfig)
    options(pgobj.blobs=pginfo$blobs)


    #### connect with database
    pgobjects::PgObjectsInit(dbname=pginfo$dbname,
                  user=pginfo$user,
                  passwd=pginfo$passwd,
                  host=pginfo$host,
                  schema=pginfo$schema
                  )




}

#' drname add
#' @export
getDatacubeConfig <- function() {

    dcinfo <- get("dcinfo",env=.DatacubeConfig)
    pginfo <- get("pginfo",env=.DatacubeConfig)
    keyvalProject <- get("keyvalProject",env=.DatacubeConfig)


    return(list(dcinfo=dcinfo,
                pginfo=pginfo,
                keyvalProject=keyvalProject))




}
