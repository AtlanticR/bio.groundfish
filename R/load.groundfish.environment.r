load.groundfish.environment = function( libs=NULL, p=NULL ) {

  if (is.null(p)) p = list()

  # libraries
  # note chron is deprecated -- use lubridate as it is faster and more general
  p$libs = RLibrary( "Hmisc", "date", "chron", "lubridate", "vegan", "fields", "sp",
    "rgdal", "raster" , "INLA", "numDeriv", "lubridate", "geosphere" )

  # helper functions
  p$libs = unique( c( p$libs, bioLibrary( "bio.spacetime", "bio.utilities", "bio.taxonomy",
    "netmensuration", "bio.temperature", "bio.habitat", "bio.bathymetry",
    "bio.bio", "groundfish", "bio.polygons", "bio.coastline" ) ) ) #,"BIOsurvey" ) )

  if (!is.null(libs)) p$libs = unique( c(p$libs, RLibrary(libs) ) )

  p$R.gs = file.path( project.datadirectory("groundfish"), "R" )

  setwd( p$R.gs )
  assign("R.gs", p$R.gs,  envir=parent.frame() ) # export to calling namespace .. should not be needed but just in case
  return( p )

}

