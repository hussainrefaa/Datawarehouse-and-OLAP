-- Author: 	Hussain refaa
-- creation Date: 	2016
-- Last Updated: 	0000-00-00
-- Control Number:	xxxx-xxxx-xxxx-xxxx
-- Subject :        Etl Sample
-- Version: 	0.0
-- Phone : +4915775148443
-- Email: hus244@gmail.com

1) CREATE Table in database
  
create table employee (empname nvarchar2(32) ) ; 

insert into employee values('Hussain Refaa');

commit;

2) CREATE Dirictory in c:\TEMP

3) CREATE correspondig logical directory in oracle
   Using SQL
   
   Create directory etl_dir as 'c:\TEMP'
4) Export table using expdp command in normal command line
expdp c##scott dumpfile=employee.dmp logfile=employee.log tables=employee directory=etl_dir

export complete

5) now drop table from database

6) now import table from local file system using impdp 
   impdp command is same as except changing logfile name
   
impdp c##scott dumpfile=employee.dmp logfile=employee.log tables=employee directory=etl_dir
im complete
