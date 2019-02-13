#' set project key value pairs
#'
#' sets project key value pairs
#'
#' @export

setprojkeyval <- function(scriptdir=NA) {
    # 
    #     keyval.project <- list(repository=scriptdir$repo,
    #                project=scriptdir$project,
    #                script=scriptdir$file)
    #     keyval.project <- append(keyval.project,keyvalgit())
    #     return(keyval.project)


    git <- gitInfo()
    dcinfo <- get("dcinfo",env=.DatacubeConfig)
    kv<- list(repo=git$repo,
              project=dcinfo$workdir,
              script=dcinfo$script,
              modified=as.character(git$modified),
              sha=git$sha,
              remote=git$remote,
              branch=git$branch
              )

    assign("keyvalProject",kv,env=.DatacubeConfig)
    invisible(kv)

}
