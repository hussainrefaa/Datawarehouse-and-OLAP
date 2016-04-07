
-- Author: 	Hussain refaa
-- creation Date: 	2008
-- Last Updated: 	0000-00-00
-- Control Number:	xxxx-xxxx-xxxx-xxxx
-- Version: 	0.0
-- Phone : +4915775148443
-- Email: hus244@gmail.com/
CREATE TYPE unit_cost_price_row AS OBJECT (
   aw_unit_cost     NUMBER,
   aw_unit_price    NUMBER,
   aw_product       VARCHAR2 (50),
   aw_product_gid   NUMBER (10),
   aw_time          VARCHAR2 (20),
   aw_time_gid      NUMBER (10),
   r2c              RAW (32)
);

---------------------------------------------
CREATE OR REPLACE VIEW unit_cost_price_view
AS
   SELECT aw_unit_cost, aw_unit_price, aw_product, aw_product_gid, aw_time,
          aw_time_gid, r2c
     FROM TABLE
             (olap_table
                 ('global DURATION SESSION',
                  'unit_cost_price_table',
                  '',
                  'MEASURE aw_unit_cost FROM price_cube_unit_cost
MEASURE aw_unit_price FROM price_cube_unit_price
DIMENSION product WITH
HIERARCHY product_parentrel
INHIERARCHY product_inhier
GID aw_product_gid FROM product_gid
ATTRIBUTE aw_product FROM product_short_description
DIMENSION time WITH
HIERARCHY time_parentrel
INHIERARCHY time_inhier
GID aw_time_gid FROM time_gid
ATTRIBUTE aw_time FROM time_short_description
ROW2CELL r2c'
                 )
             );

-----------------------------
SELECT   *
    FROM unit_cost_price_view
   WHERE aw_product = 'Hardware'
     AND aw_time IN ('2000', '2001', '2002', '2003')
ORDER BY aw_time;


SELECT   *
    FROM unit_cost_price_view
   WHERE aw_product = 'Hardware'
     AND aw_time IN ('2000', '2001', '2002', '2003')
     AND olap_condition (r2c,
                         'limit time to time_short_description eq ''2000''',
                         0
                        ) = 1
ORDER BY aw_time;



SELECT   *
    FROM unit_cost_price_view
   WHERE aw_product = 'Hardware'
     AND aw_time IN ('2000', '2001', '2002', '2003')
     AND olap_condition (r2c,
                         'limit time to time_short_description eq ''2000''',
                         1
                        ) = 1
ORDER BY aw_time;


--Check status in the analytic workspace
/*FMT(71) NOT FORMATTED DUE TO ERROR !!! */
SQL>exec dbms_aw.execute('rpr time_short_description');   /*FMT(71) ERROR:
Unrecognized command(s) or statement(s)
Input line 71 (near output line 72), col 1

*/
/*FMT(71) END UNFORMATTED */




SELECT   *
    FROM unit_cost_price_view
   WHERE aw_product = 'Hardware'
     AND aw_time IN ('2000', '2001', '2002', '2003')
     AND olap_condition (r2c,
                         'limit time to time_short_description eq ''2000''',
                         2
                        ) = 1
ORDER BY aw_time;


--------------------------------
--- OLAP_EXPRESSION Examples

CREATE TYPE unit_cost_price_row AS OBJECT (
   aw_unit_cost    NUMBER,
   aw_unit_price   NUMBER,
   aw_product      VARCHAR2 (50),
   aw_time         VARCHAR2 (20),
   r2c             RAW (32)
);
/

-- Create the logical table

CREATE TYPE unit_cost_price_table AS TABLE OF unit_cost_price_row;
/

-- Create the view
CREATE OR REPLACE VIEW unit_cost_price_view
AS
   SELECT aw_unit_cost, aw_unit_price, aw_product, aw_time, r2c
     FROM TABLE
             (olap_table
                 ('global DURATION SESSION',
                  'unit_cost_price_table',
                  '',
                  'MEASURE aw_unit_cost FROM price_cube_unit_cost
MEASURE aw_unit_price FROM price_cube_unit_price
DIMENSION product WITH
HIERARCHY product_parentrel
INHIERARCHY product_inhier
ATTRIBUTE aw_product FROM product_short_description
DIMENSION time WITH
HIERARCHY time_parentrel
INHIERARCHY time_inhier
ATTRIBUTE aw_time FROM time_short_description
ROW2CELL r2c'
                 )
             );
/
SELECT   *
    FROM unit_cost_price_view
   WHERE aw_product = 'Hardware'
     AND aw_time IN ('2000', '2001', '2002', '2003')
ORDER BY aw_time;


SELECT aw_time TIME, aw_unit_cost unit_cost,
       olap_expression
          (r2c,
           'LAG(price_cube_unit_cost, 1, time,
LEVELREL time_levelrel)'
          ) periodago
  FROM unit_cost_price_view
 WHERE aw_product = 'Hardware'
   AND olap_expression
                 (r2c,
                  'LAG(price_cube_unit_cost, 1, time,
LEVELREL time_levelrel)'
                 ) > 50000;


/*FMT(155) NOT FORMATTED DUE TO ERROR !!! */
SELECT aw_time time, aw_unit_cost unit_cost, aw_unit_price unit_price,
OLAP_EXPRESSION(r2c,
'PRICE_CUBE_UNIT_PRICE - PRICE_CUBE_UNIT_COST') markup
FROM unit_cost_price_view
WHERE aw_product = 'Hardware'
AND aw_time in ('1998', '1999', '2000', '2001')
ORDER BY OLAP_EXPRESSION(r2c,
'PRICE_CUBE_UNIT_PRICE - PRICE_CUBE_UNIT_COST') DESC

--------------------------------------------
---------- OLAP_EXPRESSION_BOOL example
-- Create the logical row
CREATE TYPE awunits_row AS OBJECT (
awtime VARCHAR2(12),
awcustomer VARCHAR2(30),
awproduct VARCHAR2(30),
awchannel VARCHAR2(30),
awunits NUMBER(16),
r2c RAW(32))  /*FMT(155) ERROR:
Input line 167 (near output line 166), col 1
(S1017) Expecting:    ,   statement_terminator   ;   FOR  NULLS  ORDER
*/
/*FMT(155) END UNFORMATTED */
;
/
-- Create the logical table

CREATE TYPE awunits_table AS TABLE OF awunits_row;
/

-- Create the view
CREATE OR REPLACE VIEW awunits_view
AS
   SELECT awunits, awtime, awcustomer, awproduct, awchannel, r2c
     FROM TABLE
             (olap_table
                 ('global_aw.globalaw DURATION SESSION',
                  'awunits_table',
                  '',
                  'MEASURE awunits FROM units_cube_aw_units_aw
DIMENSION awtime FROM time_aw WITH
HIERARCHY time_aw_parentrel
DIMENSION awcustomer FROM customer_aw WITH
HIERARCHY customer_aw_parentrel
(customer_aw_hierlist ''MARKET_ROLLUP_AW'')
INHIERARCHY customer_aw_inhier
DIMENSION awproduct FROM product_aw WITH
HIERARCHY product_aw_parentrel
DIMENSION channel_aw WITH
HIERARCHY channel_aw_parentrel
ATTRIBUTE awchannel FROM channel_aw_short_description
ROW2CELL r2c'
                 )
             )
    WHERE awunits IS NOT NULL;
/
/*FMT(212) NOT FORMATTED DUE TO ERROR !!! */
The following query shows some of the aggregate data in the view. For all products in
all markets during the year 2001, it shows the number of units sold through each
channel.
SQL> SELECT awchannel, awunits FROM awunits_view  /*FMT(212) ERROR:
Unrecognized command(s) or statement(s)
Input line 212 (near output line 213), col 1

*/
/*FMT(212) END UNFORMATTED */




/*FMT(225) NOT FORMATTED DUE TO ERROR !!! */
WHERE awproduct = '1'
AND awcustomer = '7'
AND awtime = '4';
 SQL>execute dbms_aw.execute('limit product_aw to ''1''');
SQL>execute dbms_aw.execute('rpr product_aw_short_description');
 /*FMT(225) ERROR:
Input line 227 (near output line 226), col 17
(S88) Expecting:   (+)   )    *   **   +    ,    -    /
statement_terminator   ;   <<"  <<<  ||  AND  AS  AT  BEGIN  CALL
COMPOSITE_LIMIT  COMPRESS  COMPUTE  CONNECT  CONNECT_TIME
CPU_PER_CALL  CPU_PER_SESSION  CREATE  CROSS  DAY  DECLARE  ELSE  END
FAILED_LOGIN_ATTEMPTS  FOLLOWING  FOR  FULL  GRANT  GROUP  HAVING
IDLE_TIME  INITRANS  INNER  INTERSECT  JOIN  LEFT  LOCAL  LOCATION
LOGGING  LOGICAL_READS_PER_CALL  LOGICAL_READS_PER_SESSION  LOOP
MAXTRANS  MINUS  MOD  NATURAL  NOCOMPRESS  NOLOGGING  NOPARALLEL
NOSORT  ON  ONLINE  OR  ORDER  PARALLEL  PASSWORD_GRACE_TIME
PASSWORD_LIFE_TIME  PASSWORD_LOCK_TIME  PASSWORD_REUSE_MAX
PASSWORD_REUSE_TIME  PASSWORD_VERIFY_FUNCTION  PCTFREE  PCTUSED
PRECEDING  PRIVATE_SGA  RECOVERABLE  REM  RETURN  RETURNING  REVERSE
RIGHT  SESSIONS_PER_USER  START  STORAGE  TABLESPACE  THEN  UNION
UNRECOVERABLE  USING  WHEN  WHERE  WITH  YEAR
*/
/*FMT(225) END UNFORMATTED */
/*FMT(251) NOT FORMATTED DUE TO ERROR !!! */
SQL>execute dbms_aw.execute('limit customer_aw to ''7''');
SQL>execute dbms_aw.execute('rpr customer_aw_short_description');  /*FMT(251) ERROR:
Unrecognized command(s) or statement(s)
Input line 251 (near output line 252), col 1

*/
/*FMT(251) END UNFORMATTED */




SELECT awproduct products,
       olap_expression_bool (r2c,
                             'units_cube_aw_units_aw le 500'
                            ) lowest_units
  FROM awunits_view
 WHERE awproduct > 39
   AND awproduct < 46
   AND awcustomer = '7'
   AND awchannel = 'Internet'
   AND awtime = '4';
/*FMT(273) NOT FORMATTED DUE TO ERROR !!! */
sql> execute dbms_aw.execute
('limit product_aw to product_aw gt 39 and product_aw lt 46');

sql> execute dbms_aw.execute('rpr product_aw_short_description');  /*FMT(273) ERROR:
Unrecognized command(s) or statement(s)
Input line 273 (near output line 273), col 1

*/
/*FMT(273) END UNFORMATTED */




---------------------------------------------------------------------------
---- OLAP_EXPRESSION_DATE example

--- OLAP_EXPRESSION_TEXT
---------------------------------------------------------------------------
--- Script for a Rollup View of Products Using OLAP_TABLE
-- create aw anlytical worplace
EXECUTE dbms_aw.execute ('report w 40 name');

EXECUTE OLAP_ViewGenerator.createAWViews (user,'report w 40 name');

EXECUTE OLAP_ViewGenerator.createCubeView (user,'report w 40 name','Test Cube') ;


CREATE TYPE awproduct_row AS OBJECT (
   CLASS    VARCHAR2 (50),
   family   VARCHAR2 (50),
   item     VARCHAR2 (50)
);
/

CREATE TYPE awproduct_table AS TABLE OF awproduct_row;

CREATE OR REPLACE VIEW awproduct_view
AS
   SELECT CLASS, family, item
     FROM TABLE
             (olap_table
                 ('report w 40 name',
                  'awproduct_table',
                  '',
                  'DIMENSION product WITH
HIERARCHY product_parentrel
FAMILYREL null, class, family, item
FROM product_familyrel USING product_levellist
LABEL product_short_description'
                 )
             );

SELECT   *
    FROM awproduct_view
ORDER BY CLASS, family, item;


CREATE OR REPLACE TYPE awproduct_row AS OBJECT (
   CLASS    VARCHAR2 (50),
   family   VARCHAR2 (50),
   item     VARCHAR2 (50)
);
/

CREATE TYPE awproduct_table AS TABLE OF awproduct_row;
/

CREATE OR REPLACE VIEW awproduct_view
AS
   SELECT CLASS, family, item
     FROM TABLE
             (olap_table
                 ('global DURATION QUERY',
                  'awproduct_table',
                  '',
                  'DIMENSION product WITH
HIERARCHY product_parentrel
FAMILYREL class, family, item FROM
product_familyrel(product_levellist ''CLASS''),
product_familyrel(product_levellist ''FAMILY''),
product_familyrel(product_levellist ''ITEM'')
LABEL product_short_description'
                 )
             );

SELECT * FROM awproduct_view
ORDER BY by class, family, item  /*FMT(359) ERROR:
Input line 360 (near output line 359), col 10
(S27) Expecting:    (    *    +    -   string   :   CASE  CAST  CURSOR
 DATE  decimal number  decimal number  EXTRACT  FALSE  identifier
integer  INTERVAL  MULTISET  NULL  PRIOR  SQL  THE  TIMESTAMP  TREAT
TRUE
*/
/*FMT(359) END UNFORMATTED */
;
-------------------------------
--- OLAP_TABLE example

CREATE TYPE time_cal_row AS OBJECT (
   time_id           VARCHAR2 (32),
   cal_short_label   VARCHAR2 (32),
   cal_end_date      DATE,
   cal_timespan      NUMBER (6)
);

CREATE TYPE time_cal_table AS TABLE OF time_cal_row;

EXECUTE dbms_aw.execute ('report w 40 name');

CREATE OR REPLACE VIEW time_cal_view
AS
   SELECT time_id, cal_short_label, cal_end_date, cal_timespan
     FROM TABLE
             (olap_table
                 ('global_aw.global report w 40 name',
                  'time_cal_table',
                  '',
                  'DIMENSION time_id from time with
HIERARCHY time_parentrel
INHIERARCHY time_inhier
ATTRIBUTE cal_short_label from time_short_description
ATTRIBUTE cal_end_date from time_end_date
ATTRIBUTE cal_timespan from time_time_span'
                 )
             );
