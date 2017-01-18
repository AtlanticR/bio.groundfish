
p = bio.groundfish::load.groundfish.environment(assessment.year = 2016)

# these should be run on a windows machine: NULL values get mangled for some reason
p$odbc.data.yrs=p$assessment.year  #  <<<<< ---- DATA YEAR can be a single year update too
groundfish.db( DS="odbc.redo", datayrs=p$odbc.data.yrs )

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
  # requires gsinf
  p$netmensuration.years = p$assessment.year # for a single year update
  # p$netmensuration.years = c(1990:1992, 2004:p$assessment.year)  # or ..

  # set id's that should be skipped:: corrupted/improper due to faulty sensor data, etc.
  p$problem.sets = c("NED2014018.27", "NED2014101.11", "NED2014101.12", "NED2014101.13",  "NED2014101.14",
          "NED2010027.143")

  # the following works upon many or annual time slices ( defined in p$netmensuration.years )
  scanmar.db( DS="basedata.redo", p=p )        # Assimilate Scanmar files in raw data saves *.set.log files
  scanmar.db( DS="basedata.lookuptable.redo", p=p ) # match modern data to GSINF positions and extract Mission/trip/set ,etc
  scanmar.db( DS="sanity.checks.redo",  p=p )      # QA/QC of data
  scanmar.db( DS="bottom.contact.redo",  p=p )  # bring in estimates of bottom contact times from scanmar

  # netmind base data filtered for fishing periods .. not really used except for some plots
  scanmar.db( DS="scanmar.filtered.redo",  p=p )

  figures.netmensuration( DS="all", p=p )
  # figures.netmensuration( DS="all", p=p, outdir=p$netmens.dir  )
  # see scripts/99.example.netmensuration.r for some additional figures, etc.

}

# swept areas are computed in bottom.contact.redo ..
# this step estimates swept area for those where there was insufficient data to compute SA directly from logs,
# estimate via approximation using speed etc.
groundfish.db( DS="sweptarea.redo")  ## this is actually gsinf with updated data, etc.

groundfish.db( DS="gshyd.profiles.redo" )
groundfish.db( DS="gshyd.redo" )
groundfish.db( DS="gshyd.georef.redo" )  # not used here but used in temperature re-analysis

# lookupregion = lookup.strata()  # create strata vs region lookup table

# merged data sets
groundfish.db( DS="set.base.redo" ) # set info .. includes scanmar.db("sweptarea")
groundfish.db( DS="cat.base.redo" ) # catches
groundfish.db( DS="det.base.redo") # determined factors
groundfish.db( DS="cat.redo" ) # catches .. add correction factors, and express per unit area
groundfish.db( DS="det.redo" ) # determined data (length, weight etc)
groundfish.db( DS="set.det.redo", taxa=p$taxa.of.interest ) # add determined data summaries
groundfish.db( DS="catchbyspecies.redo", taxa=p$taxa.of.interest )
groundfish.db( DS="set.redo" ) # finalize

# create a lookuptable for data transformations
REPOS = bio.indicators::recode.variable.initiate.db ( db="groundfish" )

