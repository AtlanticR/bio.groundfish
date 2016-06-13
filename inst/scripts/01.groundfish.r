
# the following create the basic datafiles from the database


# ------------------  Common initialisation for groundfish

  p = bio.groundfish::load.groundfish.environment()

# not too many as it has high memory requirements
# clusters=c("tethys", "tethys", "io", "io", "io" )
# clusters=c("tethys", "tethys", "tethys", "tethys", "lotka")
# clusters=rep("kaos",10)
  p$clusters = rep("localhost", detectCores() )

# choose taxa or taxonomic groups of interest
  p$taxa.of.interest = variable.list.expand("catch.summary")
  p$season = "summer"
  p = spatial.parameters( p, "SSE" )  # data are from this domain .. so far
  p$taxa =  "maxresolved"
  p$nw = 10  # from temperature.r, number of intervals in a year


# ---------
# primary data sets
# these should be run on a windows machine: NULL values get mangled for some reason
  p$year.assessment = 2015

  odbc.data.yrs=1970:p$year.assessment
    #  <<<<< ---- DATA YEAR can be a single year update too
    # --- for import of data year only

  groundfish.db( DS="odbc.redo", datayrs=odbc.data.yrs )


  refresh.bio.species.codes = FALSE
  if (refresh.bio.species.codes ) {
    # the following is copied from taxonomy/src/taxonomy.r
    groundfish.db( DS="spcodes.odbc.redo" )
    # bootstrap an initial set of tables .. these will be incomplete as a parsimonious tree needs to be created first but
    # it depends upon the last file created taxonomy.db("complete") .. so ...
    taxonomy.db( "groundfish.itis.redo" )  ## link itis with groundfish tables using taxa names, vernacular, etc
    taxonomy.db( "full.taxonomy.redo" )  # merge full taxonomic hierrachy (limit to animalia and resolved to species)
		## taxonomy.db( "parsimonious.redo" )  # (re)create lookups from old codes to a parsimonious species list
    taxonomy.db( "life.history.redo" ) # add life history data (locally maintained in groundfish.lifehistory.manually.maintained.csv )
    taxonomy.db( "complete.redo" )
    taxonomy.db( "parsimonious.redo" )
  }


  groundfish.db( DS="gscat.redo" )
  groundfish.db( DS="gsdet.redo" )
  groundfish.db( DS="gsinf.redo" )


  netmensuration.do = FALSE
  if ( netmensuration.do ) {
    # done here as it requires an up-to-date gsinf

    # define location of local data files
    p$scanmar.dir = file.path( project.datadirectory("bio.groundfish"), "data", "nets", "Scanmar" )
    p$marport.dir = file.path( project.datadirectory("bio.groundfish"), "data", "nets", "Marport" )

    # pick the year to process:
    # 2009 is the first year with set logs from scanmar available .. if more are found, alter this date
    # p$netmensuration.years = p$assessment.year # for a single year update
    p$netmensuration.years = c(1990:1992, 2004:p$assessment.year)  # or ..

    # set id's that should be skipped:: corrupted/improper due to faulty sensor data, etc.
    p$problem.sets = c("NED2014018.27", "NED2014101.11", "NED2014101.12", "NED2014101.13",  "NED2014101.14",
            "NED2010027.143")

    # the following works upon many or annual time slices ( defined in p$netmensuration.years )
    scanmar.db( DS="basedata.redo", p=p )        # Assimilate Scanmar files in raw data saves *.set.log files
    scanmar.db( DS="basedata.lookuptable.redo", p=p ) # match modern data to GSINF positions and extract Mission/trip/set ,etc
    scanmar.db( DS="sanity.checks.redo",  p=p )      # QA/QC of data

    scanmar.db( DS="bottom.contact.redo",  p=p )  # bring in estimates of bottom contact times from scanmar

    # swept areas are computed in bottom.contact.redo ..
    # this step estimates swept area for those where there was insufficient data to compute SA directly from logs,
    # estimate via approximation using speed etc.
    scanmar.db( DS="sweptarea.redo",  p=p )
    figures.netmensuration( DS="all", p=p )

    # netmind base data filtered for fishing periods .. not really used except for some plots
    scanmar.db( DS="scanmar.filtered.redo",  p=p )

    # see scripts/99.example.netmensuration.r for some additional figures, etc.

  }


  groundfish.db( DS="gshyd.profiles.redo" )
  groundfish.db( DS="gshyd.redo" )
  groundfish.db( DS="gshyd.georef.redo" )  # not used here but used in temperature re-analysis


# lookupregion = lookup.strata()  # create strata vs region lookup table

# ---------
# merged data sets
  groundfish.db( DS="set.base.redo" )  --- TODO :: add routines to absord scanmar.db into set.base
  groundfish.db( DS="cat.base.redo" )
  groundfish.db( "det.base.redo")#, r2crit=0.75 ) # ~ 10 min

  groundfish.db( "cat.redo" )  # add correction factors, and express per unit area
  groundfish.db( "det.redo" ) # ~ 10 min on io

  groundfish.db( "catchbyspecies.redo", taxa=p$taxa.of.interest )


# ---------
# 3. sm_det.rdata .. summarize condition
  groundfish.db( "set.det.redo", taxa=p$taxa.of.interest )
  groundfish.db( "set.complete.redo", p=p )


# -------------------------------------------------------------------------------------
# Run bio.habitat to update the multi-survey databases
# -------------------------------------------------------------------------------------


# create a lookuptable for data transformations
  REPOS = recode.variable.initiate.db ( db="groundfish" )





