#' Init Datacube
#'
#' initialiaze datacube
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


    #### connect with database
    pgobjects::PgObjectsInit(dbname=getOption(paste(database,"dbname",sep=".")),
                  user=getOption(paste(database,"user",sep=".")),
                  passwd=getOption(paste(database,"password",sep=".")),
                  host=getOption(paste(database,"host",sep=".")),
                  schema=getOption(paste(database,"schema",sep="."))
                  )




}

getDatacubeConfig <- function() {

    dcinfo <- get("dcinfo",env=.DatacubeConfig)
    keyvalProject <- get("keyvalProject",env=.DatacubeConfig)


    return(list(dcinfo=dcinfo,
                keyvalProject=keyvalProject))




}
