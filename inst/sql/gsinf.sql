set pagesize 10000
set arraysize 5000
set linesize 500
set colsep ;;
set pause off
set tab off
set term off
set flush off
spool /users/choij/gsinf.dat
select MISSION, SETNO, STRAT, SLAT, SLONG, AREA, DUR, DIST, SPEED, DMIN, DMAX, WIND, FORCE, CURNT, TYPE, GEAR, AUX, DEPTH, START_DEPTH, END_DEPTH 
from groundfish.gsinf;

