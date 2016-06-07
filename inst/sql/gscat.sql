set pagesize 10000
set arraysize 5000
set linesize 500
set colsep ;;
set pause off
set tab off
set term off
set flush off
spool /users/choij/gscat.dat
select MISSION, SETNO,  SPEC, MARKET, SAMPWGT, TOTWGT, TOTNO, CALWT, SIZE_CLASS
from groundfish.gscat;

