load.groundfish.environment = function() {
  # libraries
  # note chron is deprecated -- use lubridate as it is faster and more general
  init.libs = RLibrary( "Hmisc", "date", "chron", "lubridate", "vegan", "fields", "sp", "rgdal", "raster" )

  # helper functions
  init.ecomodLibs = ecomodLibrary( c( "plottingmethods", "spacetime", "utility", "parallel", "taxonomy",
  "netmensuration", "temperature", "habitat", "bathymetry", "bio", "groundfish", "polygons", "coastline" ))#,"BIOsurvey" ) )
  R.gs = file.path( project.datadirectory("groundfish"), "R" )
  setwd( R.gs )
  return( list( init.libs, init.ecomodLibs ) )
}

