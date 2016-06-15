load.groundfish.environment = function( libs=NULL, p=NULL, assessment.year=NULL  ) {

  if (is.null(p)) p = list()

  rlibs = RLibrary( "Hmisc", "date", "lubridate", "vegan", "fields", "sp",
    "rgdal", "raster" , "INLA", "numDeriv", "lubridate", "geosphere", "parallel" )

  blibs = bioLibrary( "bio.spacetime", "bio.utilities", "bio.taxonomy",
    "netmensuration", "bio.temperature", "bio.habitat", "bio.bathymetry",
    "bio.groundfish", "bio.polygons", "bio.coastline" )

  if (!is.null(libs)) libs = RLibrary(libs)
  if (exists("libs", p)) libs = c(libs, p$libs)

  p$libs = unique( c( libs, rlibs, blibs) )

  if (is.null (assessment.year ) ) {
    p$assessment.year = lubridate::year( Sys.Date() )
  } else {
    p$assessment.year = assessment.year
  }

  p$taxa.of.interest = variable.list.expand("catch.summary")
  p$season = "summer"
  p = spatial.parameters( p, "SSE" )  # data are from this domain .. so far
  p$taxa =  "maxresolved"
  p$nw = 10  # from temperature.r, number of intervals in a year

  p$R.gs = file.path( project.datadirectory("bio.groundfish"), "R" )


  setwd( p$R.gs )

  # export to calling namespace .. should not be needed but just in case
  assign("R.gs", p$R.gs,  envir=parent.frame() )

  return( p )

}

