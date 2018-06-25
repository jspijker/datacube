#' set project key value pairs
#'
#' sets project key value pairs
#'
#' @export

setprojkeyval <- function(scriptdir) {

    keyval.project <- list(repository=scriptdir$repo,
			   project=scriptdir$project,
			   script=scriptdir$file)
    keyval.project <- append(keyval.project,keyvalgit())
    return(keyval.project)

}
