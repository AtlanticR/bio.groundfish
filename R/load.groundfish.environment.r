load.groundfish.environment = function() {
  # libraries
  # note chron is deprecated -- use lubridate as it is faster and more general
  init.libs = RLibrary( "Hmisc", "date", "chron", "lubridate", "vegan", "fields", "sp", "rgdal", "raster" , "INLA", "numDeriv", "lubridate", "geosphere" )

  # helper functions
  init.ecomodLibs = ecomodLibrary( c( "plottingmethods", "spacetime", "utility", "parallel", "taxonomy",
  "netmensuration", "temperature", "habitat", "bathymetry",
  "bio", "groundfish", "polygons", "coastline" ))#,"BIOsurvey" ) )
  R.gs = file.path( project.datadirectory("groundfish"), "R" )
  setwd( R.gs )
  assign("R.gs", R.gs,  envir=parent.frame() ) # export to calling namespace .. should not be needed but just in case
  return( list( libs=init.libs, inits=init.ecomodLibs ) )
}

