load.groundfish.environment = function( libs=NULL, p=NULL, assessment.year=NULL  ) {

  if (is.null(p)) p = list()

  rlibs = RLibrary( "Hmisc", "date", "lubridate", "vegan", "fields", "sp",
    "rgdal", "raster" , "INLA", "numDeriv", "lubridate", "geosphere", "parallel" )

  blibs = bioLibrary( "bio.spacetime", "bio.utilities", "bio.taxonomy",
    "netmensuration", "bio.temperature", "bio.bathymetry",
    "bio.groundfish", "bio.polygons", "bio.coastline" )

  if (!is.null(libs)) libs = RLibrary(libs)
  if (exists("libs", p)) libs = c(libs, p$libs)

  p$libs = unique( c( libs, rlibs, blibs) )

  if (is.null (assessment.year ) ) {
    p$assessment.year = lubridate::year( Sys.Date() )
  } else {
    p$assessment.year = assessment.year
  }

  p$odbc.data.yrs=1970:p$assessment.year
  p$netmensuration.years = c(1990:1992, 2004:p$assessment.year) # 2009 is the first year with set logs from scanmar available .. if more are found, alter this date


  p$taxa.of.interest = variable.list.expand("catch.summary")
  p$season = "summer"
  p = spatial_parameters( p, "SSE" )  # data are from this domain .. so far
  p$taxa =  "maxresolved"
  p$nw = 10  # from temperature.r, number of intervals in a year
  p$clusters = rep("localhost", detectCores() )

  p$R.gs = file.path( project.datadirectory("bio.groundfish"), "R" )

  # define location of local data files
    p$scanmar.dir = file.path( project.datadirectory("bio.groundfish"), "data", "nets", "Scanmar" )
    p$marport.dir = file.path( project.datadirectory("bio.groundfish"), "data", "nets", "Marport" )
    p$netmens.dir = file.path( project.datadirectory("bio.groundfish"), "data", "nets", "netmensuration" )


  setwd( p$R.gs )

  # export to calling namespace .. should not be needed but just in case
  assign("R.gs", p$R.gs,  envir=parent.frame() )

  return( p )

}

