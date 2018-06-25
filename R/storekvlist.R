#' store key-value pairs
#'
#' Key-value pairs can be stored in pgobjects database, this function
#' stores key-value pairs based on a list
#'
#' @export

storekvlist <- function(kv,name) {

	# check names of kv
	kv.names <- names(kv)
	if(is.null(kv.names)) {
		stop("kv list does not contain key values")
	}

	for (i in kv.names) {
		if(i=="") {
			stop(paste("kv list does not contain key values for key",i))
		}
		val=kv[[i]]
		if(!is.character(val)) {
			stop(paste("kv list is not character does not contain
					   character value for key",i))
		}
		if(val=="") {
			stop(paste("kv list does not contain value values for key",i))
		}
	}

	for (i in names(kv)) {
		 storeKeyval(obj=name,key=i,val=kv[[i]],overwrite=TRUE)
	 }
}



