#' Show datacube objects in database
#'
#' This function returns a data.frame with the name and description of all the objects and their
#' automatically generated metadata
#'
#' @param schema database schema where the objects are stored
#'
#' @return data.frame with object names, description and automatically
#' generated meta data
#'
#'
#' @importFrom dplyr select filter
#' @importFrom tidyr spread 
#' @export



getobjlist <- function(schema="datacube") {
    x <- pgobjects::sql(paste("select robjects.name,key,value from ",schema,".robjects,",schema,".rkeyvalue 
                              where robjects.did=rkeyvalue.did;",sep=""))

    auditObjs <- x %>% filter(key=="audit") %>%
        select(name)
    
    objs <- x %>% filter(!name%in%auditObjs$name)

    dcKeys <- names(getkeyval())

    objs <- objs %>% filter(key %in% c(dcKeys,"description")) %>% 
        spread(key,value) %>%
        na.omit() %>%
        select(dcKeys,name,description)

    return(objs)
}

