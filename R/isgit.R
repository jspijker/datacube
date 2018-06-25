#' Determine if git repo is present
#'
#' Returns TRUE if working directory is a git repository
#'
#' @export

isGit <- function() {

    suppressWarnings(
		    git <- system2("git","rev-parse ",
				   stdout=TRUE,stderr=FALSE)
		    )


    if(!is.null(attributes(git))) {
	isGit <- FALSE
    } else {
	isGit <- TRUE
    }

    return(isGit)

}
     
