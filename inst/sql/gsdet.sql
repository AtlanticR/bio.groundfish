set pagesize 10000
set arraysize 5000
set linesize 500
set colsep ;;
set pause off
set tab off
set term off
set flush off
spool /users/choij/gsdet.dat
select MISSION, SETNO, SPEC, FSHNO, FLEN, FSEX, FMAT, FWT, AGMAT, NANN, EDGE, CHKMRK, AGE, AGER, CLEN, SIZE_CLASS 
from groundfish.gsdet;

