
Introduction
============

The RIVM datacube is a data repository aimed at spatial grid based data, although it can manage any kind of data. It is used in our data-science projects involving spatial analyses, modeling and prediction It is suitable for combining field measurements, e.g. from monitoring networks, with other spatial data (e.g. soil types, groundwater levels, land use, altitude, crops, emission data etc.). All the spatial data in the datacube is georeferenced to the same extent, so maps can be stacked easily. These stacks are the actual datacubes we use in our machine learning models.

This package contains functions to work with GIS data and PostGIS, it manages data by storing data to the repository, generate meta-data, creates audit trails or data lineage paths, and stores versioning info. It is aimed at small teams working together with the same data. The datacube package makes it possible to work on projects which are reusable, reproducible and auditable.

important
=========

*Please note:* this is work in progress. This package needs git and PostgreSQL/PostGIS for proper working. It assumes a Linux OS (it might work under Windows but we never tried).

Installation in R , using the devtools package: `devtools::install_github("jspijker/datacube")` Please make sure you already have the fasterize and the here package installed.

Dependencies
============

The datacube package uses 3 other related packages: pgobjects is a package to store R objects, either variables, functions, or complete environments, into a PostgreSQL database. The pgblobs package is an extension of pgobjects. If objects are to big to store in the database, like raster grids or spatial data, only the meta data is stored in the database and the file, or blob, is stored on a shared disk location. The localoptions package is used to read an options file with the datacube configuration:

These packages can be found on github:

[gobjects](https://github.com/jspijker/pgobjects) [pgblobs](https://github.com/jspijker/pgblobs) [localoptions](https://github.com/jspijker/localoptions)

configuration
=============

For the configuration of the system the localoptions package is used. With localoptions an option file is read with the database configuration and file locations. The default location of this option file is ~/.R.options and looks like this:

    # database host, database name, user, and password
    datacube.host localhost
    datacube.dbname datacube
    datacube.user username
    datacube.password verysecret

    # database schema for pgobjects tables (default is public)
    datacube.schema datacube

    # location to store file blobs (shared network location)
    datacube.blobs /datacube/blobs

initialization
==============

After the configuration is setup, one can load the necessary packages. We prefer to use pacman for that.

``` r
# load packages
if (!require("pacman")) install.packages("pacman")
```

    ## Loading required package: pacman

``` r
pacman::p_load(parallel,raster,ggplot2,sp,maptools,RCurl,
               RPostgreSQL,rgdal,gdalUtils,sf,fasterize,foreign,tidyverse,here)

# packages on github to use
pacman::p_load_gh("jspijker/localoptions","jspijker/pgobjects",
         "jspijker/pgblobs")

# load datacube
devtools::load_all()
```

    ## Loading datacube

After setting up the configuration, you can create your first project. Projects using the datacube package are organised withing git repositories. Each repository can contain multiple projects. For each project the user has to create a separate directory at the root of the repository.

Then the datacube is initialized, using the name of project (workdir) and the name of the script.

Part of the initialization is the setup of the database connection. Also a data directory is created and meta data about the git repository is collected. The working directory is changed to the project directory. Don't you dare to use `setwd()` in your scripts.

``` r
# initialize datacube
datacubeInit(script="README.Rmd",workdir=".")
```

    ## changing working directory to: /home/spijkerj/rivm/git/datacube/. 
    ## Creating data directory

    ## Loading required package: digest

import, tidy and transform data
===============================

To demonstrate the datacube we import data from a source location, and then tidy and transform it. For this demonstration we use the 'groenbeleving' indicator from the Dutch Health Atlas. This indicator is about the percentage of people within a municipality who are satisfied about the amount of green area in their living environment. The data is published as WFS service in the RIVM geoservice.

We'll import the spatial vector data and then transform it to a georeferenced 25x25m raster. The used georeference is a standard georeference used for all the raster layers, so all the layers can be stacked into a multidimensional raster stack. This stack is subsequently used in our machine learning models. Default, the Dutch 'Rijksdriehoekmeting' is used as projection (EPSG 28992), this can be changed by the user.

In the next section we set our variables and download the data:

``` r
# variables for data source, map layer name, and attribute
wfsuri <- "http://geodata.rivm.nl/geoserver/wfs?SERVICE=WFS&VERSION=1.0.0&REQUEST=GetFeature&TYPENAME=rivm:zorgatlas_gem_groen_2006&SRSNAME=EPSG:28992"
layername <- "zorgatlas_gem_groen_2006"
layerattribute <- "p_tevree" # name of attribute of interest

# datacube objectname
objname <- "groenbeleving" # name of raster object
objname.attr <- paste(objname,"_attr",sep="") # name of attribute table


#check layers
layers <- ogrListLayers(wfsuri)

# filename to store data:
fname.gpkg <- datafile("groenbeleving.gpkg") # see ?datacube::datafile

# get map layer, only if data does not exists (so not to waste network
# bandwidth). Store data as GeoPKG

if(!file.exists(fname.gpkg)) {
    ogr2ogr(wfsuri,fname.gpkg,
            layer=layername,
            f="GPKG")
}
```

    ## character(0)

Now that we have our vector data, we can create a raster. We use the datacube `createPixid` function to create a georeferenced reference raster. Then we use the datacube dcrasterize function to rasterize our vector data

``` r
# create pixid reference raster
pixid <- createPixid()
writeRaster(pixid,datafile("pixid.grd"),overwrite=TRUE)
```

    ## class       : RasterLayer 
    ## dimensions  : 13000, 11200, 145600000  (nrow, ncol, ncell)
    ## resolution  : 25, 25  (x, y)
    ## extent      : 0, 280000, 3e+05, 625000  (xmin, xmax, ymin, ymax)
    ## coord. ref. : +init=epsg:28992 +proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +towgs84=565.4171,50.3319,465.5524,-0.398957,0.343988,-1.87740,4.0725 +units=m +no_defs 
    ## data source : /home/spijkerj/rivm/git/datacube/data/pixid.grd 
    ## names       : layer 
    ## values      : 1, 145600000  (min, max)

``` r
# read groenbeleving vector data, using sf package
m <- st_read(fname.gpkg,stringsAsFactors=FALSE)
```

    ## Reading layer `zorgatlas_gem_groen_2006' from data source `/home/spijkerj/rivm/git/datacube/data/groenbeleving.gpkg' using driver `GPKG'
    ## Simple feature collection with 458 features and 5 fields
    ## geometry type:  MULTIPOLYGON
    ## dimension:      XY
    ## bbox:           xmin: 13421.48 ymin: 307014.7 xmax: 278049.9 ymax: 613613.3
    ## epsg (SRID):    NA
    ## proj4string:    NA

``` r
# rasterize using pixid as reference
rastfile <- dcrasterize(obj=m, 
                        layername,
                        attribute=layerattribute,
                        refraster=pixid)
```

    ## start dcrasterize
    ## using files:
    ##  /home/spijkerj/rivm/git/datacube/./data/zorgatlas_gem_groen_2006.grd 
    ##  /home/spijkerj/rivm/git/datacube/./data/zorgatlas_gem_groen_2006_attr.rds

``` r
# dcrasterize returns names of raster file and attribute table
fname.attr <- rastfile$attrfile
fname.grid <- rastfile$gridfile


# since we don't like the standard naming, we tidy the grid and
# attribute filenames.

# create raster filename
objname.grd <- datafile(paste(objname,"grd",sep="."))
x <- raster(fname.grid)
writeRaster(x,objname.grd,overwrite=TRUE)

# attribute is single file, file.rename will do
fname.attr.new <- datafile(paste(objname.attr,".rds",sep=""))
file.rename(fname.attr,fname.attr.new)
```

    ## [1] TRUE

Next, we store our results in the datacube data repository. We add extra meta data using the `kv` option.

``` r
# write attribute table as blob object
f <- dcstore(filename=fname.attr.new,
        obj=objname.attr,
        kv=list(type="rds", # meta data key-value pairs
                year="2006",
                map=objname,
                description="groenbeleving nationale zorgatlas 2006, attribute table"
                )
        )
```

    ## removing ~/work/data/blobs/groenbeleving_attr.rds 
    ## removing ~/work/data/blobs/groenbeleving_attr.rds.ini 
    ## storing blob:  ~/work/data/blobs/groenbeleving_attr.rds 
    ## storing data:  groenbeleving_attr

``` r
dcstoreraster(gridfile=objname.grd,
              blobname=objname,
              kv=list(type="GTiff",
                      year="2006",
                      attributetable=objname.attr)
              )
```

    ## grid2tif: /home/spijkerj/rivm/git/datacube/./data/groenbeleving.grd -> /home/spijkerj/rivm/git/datacube/./data/groenbeleving.tif 
    ## removing ~/work/data/blobs/groenbeleving.tif 
    ## removing ~/work/data/blobs/groenbeleving.tif.ini 
    ## storing blob:  ~/work/data/blobs/groenbeleving.tif 
    ## storing data:  groenbeleving

Using dcget and dcgetraster we can retrieve our data again

``` r
file.remove(fname.attr.new) 
```

    ## [1] TRUE

``` r
b <- dcget(objname.attr)
```

    ## storing data:  2e717927-8624-4d03-b42e-c77a231f8b31

After we got our object using `dcget` the variable `b` contains als our meta data, including information about the script which created the data:

``` r
print(b$audit$parent$script)
```

    ## [1] "README.Rmd"

``` r
print(b$audit$parent$project)
```

    ## [1] "."

``` r
print(b$audit$parent$repo)
```

    ## [1] "datacube"

data directory
==============

The datacube creates a distinct `data` directory in the current workdir to store all te data. Since this markdown script is part of a package we destroy the data directory.

``` r
unlink("./data/",recursive=TRUE)
```
