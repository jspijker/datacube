#' Get git info
#'
#' Get information about git repository
#'
#' @export



gitinfo <- function() {
    # this function returns a list with info about the current git
    # repository
    # return values are:
    # status: either commited or modified, indicating if current tree
    # is committed or not
    # commited: TRUE or FALSE, TRUE if commited
    # id: current git version id
    # branch: current branch
    # remote: list of remote urls

    warning("datacube::gitinfo function is depreciated, use gitInfo instead")

    # how to call git binary
    git.bin <-"git"

    # toplevel

    toplevel <- system2("git","rev-parse --show-toplevel",
                        stdout=TRUE)

    # get commited status
    suppressWarnings(
                     status <- system2(git.bin,c("diff", "--quiet", "HEAD"),
                                       stdout=FALSE)
                     )

    if(status>127) {
        stop(paste("git error",status))
    }

    commited <- ifelse(status==0,TRUE,FALSE)
    status <- ifelse(status==0,"commited","modified")

    # get git version id
    id <- system2(git.bin,c("rev-parse","HEAD"),
                  stdout=TRUE)

    # get git branch
    branch <- system2(git.bin,c("rev-parse","--abbrev-ref","HEAD"),
                      stdout=TRUE)


    # get info about remotes
    remoteOut <- system2(git.bin,c("remote","-v"),
                         stdout=TRUE)
    if(length(remoteOut)==0) {
        # no remote (yet)
        remote <- "none"
    } else {
        remote <- list()
        for(l in 1:length(remoteOut)) {
            x <- remoteOut[l]
            x.split <- strsplit(x,split=" |\t")[[1]]
            remote.type <- gsub("\\(|\\)","", x.split[3],perl=TRUE)
            remote[[x.split[1]]][[remote.type]] <- list() 
            remote[[x.split[1]]][[remote.type]] <- x.split[2]
        }
    }
    # return list
    info <- list(status=status, commited=commited,
                id=id,branch=branch,
                toplevel=toplevel,
                remote=remote)
    assign("gitinfo",info,env=.DatacubeConfig)
    return(info)
}

gitInfo <- function(){


    info <-list(
                root=git2r::workdir(),
                repo=basename(git2r::workdir()),
                status=git2r::status(),
                modified=ifelse(length(git2r::status()$unstaged)>0,TRUE,FALSE),
                sha=git2r::sha(git2r::last_commit()),
                branch=git2r::repository_head(git2r::repository())$name,
                remote=git2r::remote_url()[1]
                ) 
    assign("gitinfo",info,env=.DatacubeConfig)

    invisible(info)

}
