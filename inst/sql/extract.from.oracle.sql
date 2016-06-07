
telnet canso3 : choij/.kropotkin.
bash

sqlplus choij/.kropotkin. < q > /dev/null

# data dump from canso3 (choij, .kropotkin.)

set pagesize 10000
set arraysize 5000
set linesize 500
set colsep ;;
set pause off
set tab off
set term off
set flush off

#spool /users/choij/out/gs_survey_list.dat
#select * from groundfish.gs_survey_list;

spool /users/choij/out/gscat.dat
select * from groundfish.gscat;

spool /users/choij/out/gsdet.dat
select * from groundfish.gsdet;

spool /users/choij/out/gshyd.dat
select * from groundfish.gshyd;

spool /users/choij/out/gsinf.dat
select * from groundfish.gsinf;

spool /users/choij/out/gsmission_list.dat
select * from groundfish.gsmission_list;

spool /users/choij/out/gsmissions.dat
select * from groundfish.gsmissions;


... etc

# merging in oracle

set pagesize 50000
set arraysize 5000
set linesize 500
set colsep ,
set pause off
set tab off
set term off
set flush off
spool /users/choij/q.out

select  c.year, c.series, c.sdate, c.strat, c.slong, c.slat, c.totwgt, c.sampwgt, c.dist,
        d.mission, d.setno,
        d.spec species,
        d.flen length,
        d.fwt mass,
	d.age, 
	d.fmat mat,
	d.fsex sex
from    groundfish.gsdet  d,
        ( select i.year, i.series, i.sdate, i.strat, i.type, i.slong, i.slat,
                 cat.mission, cat.setno, cat.spec,
                 cat.totwgt, cat.sampwgt, i.dist
          from
                groundfish.gscat cat,
                ( select mission.year, mission.fk_series_id series, inf.setno,
                         inf.mission, inf.sdate, inf.strat, inf.dist, inf.type,
                         inf.slong, inf.slat
                  from  groundfish.gsmission_list mission,
                        groundfish.gsinf inf
                  where inf.mission(+) = mission.pk_mission
                ) i
          where
                cat.mission(+) = i.mission
          and   cat.setno(+) = i.setno
        ) c
where   d.mission(+)=c.mission
and     d.setno(+)=c.setno
and     d.spec(+)=c.spec
and     type=1
and     year = 1970
and     d.spec = 400;

