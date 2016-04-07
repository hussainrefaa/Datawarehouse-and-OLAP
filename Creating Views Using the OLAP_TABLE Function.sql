-- Author: 	Hussain refaa
-- creation Date: 	2008
-- Last Updated: 	0000-00-00
-- Control Number:	xxxx-xxxx-xxxx-xxxx
-- Version: 	0.0
-- Phone : +4915775148443
-- Email: hus244@gmail.com

AW CONNECT / as sysdba
SET ECHO ON
SET SERVEROUT ON

DROP TYPE aw_products_tbl;
DROP TYPE aw_products_obj;
DROP TYPE aw_times_tbl;
DROP TYPE aw_times_obj;
DROP TYPE aw_costs_tbl;
DROP TYPE aw_costs_obj;


-- Create objects and tables

-- Define an object that identifies the columns for product data

CREATE TYPE aw_products_obj AS OBJECT (
     prod_hier_value       VARCHAR2(35),
     prod_hier_parent      VARCHAR2(35),
     prod_id               VARCHAR2(10),
     prod_subcategory      VARCHAR2(20),
     prod_category         VARCHAR2(5),
     prod_all              VARCHAR2(15),
     prod_hier_gid         NUMBER(10));
 /    
     
     
-- Define an object that identifies the columns for times data
     

CREATE TYPE aw_times_obj AS OBJECT (
     time_hier_value       VARCHAR2(20),
     time_hier_parent      VARCHAR2(20),
     calendar_year         NUMBER(4,0),
     fiscal_year           NUMBER(4,0),
     date_id               VARCHAR2(10));
  / 
     
-- Define an object that identifies the columns for cost data
      
CREATE TYPE aw_costs_obj AS OBJECT (
     prod_hier_value       VARCHAR2(35),
     prod_hier_parent      VARCHAR2(35),
     time_hier_value       VARCHAR2(20),
     time_hier_parent      VARCHAR2(20),
     unit_cost             NUMBER(10,2),
     unit_price            NUMBER(10,2));
/      
       
-- Define a table of objects for products data
CREATE TYPE aw_products_tbl AS TABLE OF aw_products_obj;
/
-- Define a table of objects for times data
CREATE TYPE aw_times_tbl AS TABLE OF aw_times_obj;
/
-- Define a table of objects for cost data
CREATE TYPE aw_costs_tbl AS TABLE OF aw_costs_obj;
/

--- CREATE THE ANALYTIC WORKSPACE
execute dbms_aw.execute ('aw create ''myaw''');
exec CWM2_OLAP_METADATA_REFRESH.MR_REFRESH

-- Define a view of products data
CREATE OR REPLACE VIEW aw_products_view AS SELECT * FROM TABLE (CAST (OLAP_TABLE 
(
        'myaw', 'aw_products_tbl', '', 
        'DIMENSION prod_hier_value FROM aw_products 
         WITH HIERARCHY prod_hier_parent FROM aw_products.parents 
         INHIERARCHY aw_products_inhier 
         GID prod_hier_gid FROM aw_products_gid 
         LEVELREL prod_id, prod_subcategory, prod_category, prod_all 
         FROM aw_products_basevalues USING aw_products_levelnums') 
        AS aw_products_tbl));
/        
        
GRANT SELECT ON aw_products_view TO PUBLIC;    
    
-- Define a view of times data
--- CREATE THE ANALYTIC WORKSPACE
execute dbms_aw.execute ('aw create ''myaw''');
exec CWM2_OLAP_METADATA_REFRESH.MR_REFRESH

       
CREATE OR REPLACE VIEW aw_times_view AS SELECT * FROM TABLE (CAST (OLAP_TABLE (
        'awsh duration session', 'aw_times_tbl', '', 
        'DIMENSION time_hier_value FROM aw_times 
         WITH HIERARCHY time_hier_parent FROM aw_times.parents 
         ATTRIBUTE calendar_year FROM aw_calendar_year_form
         ATTRIBUTE fiscal_year FROM aw_fiscal_year_form
         ATTRIBUTE date_id FROM aw_timeid_form ') 
        AS aw_times_tbl));    
/

-- Define a view of cost data
--- CREATE THE ANALYTIC WORKSPACE
execute dbms_aw.execute ('aw create ''myaw''');
exec CWM2_OLAP_METADATA_REFRESH.MR_REFRESH

CREATE OR REPLACE VIEW aw_costs_view AS SELECT * FROM TABLE (CAST (OLAP_TABLE (
        'awsh duration session', 'aw_costs_tbl', '', 
        'MEASURE unit_cost FROM aw_unit_cost
         MEASURE unit_price FROM aw_unit_price
         DIMENSION prod_hier_value FROM aw_products 
         WITH HIERARCHY prod_hier_parent FROM aw_products.parents
         DIMENSION time_hier_value FROM aw_times 
         WITH HIERARCHY time_hier_parent FROM aw_times.parents') 
        AS aw_costs_tbl));    
/        
 
-- Grant selection rights to the views
GRANT SELECT ON aw_products_view TO PUBLIC;   
GRANT SELECT ON aw_times_view TO PUBLIC; 
GRANT SELECT ON aw_costs_view TO PUBLIC; 

--- CREATE THE ANALYTIC WORKSPACE
execute dbms_aw.execute ('aw create ''myaw''');
exec CWM2_OLAP_METADATA_REFRESH.MR_REFRESH

-- Define a view of sales data
CREATE OR REPLACE VIEW olap_sales_view AS
  SELECT * 
  FROM TABLE(OLAP_TABLE('XADEMO DURATION SESSION', 'XASALES_T', '', 
                    'MEASURE sales FROM aw_f.sales
                     DIMENSION et_chan FROM aw_channel WITH
                       HIERARCHY aw_channel.parent
                         GID gid_chan FROM aw_channel.gid
                     DIMENSION et_prod FROM aw_product WITH
                       HIERARCHY aw_product.parent
                         GID gid_prod FROM aw_prod.gid
                     DIMENSION et_geog FROM aw_geography WITH
                       HIERARCHY aw_geography.parent
                         GID gid_geog FROM aw_geog.gid
                     DIMENSION et_time FROM aw_time WITH
                       HIERARCHY time.parent
                         GID gid_time FROM aw_time.gid'));
/

