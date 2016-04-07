-- Author: 	Hussain refaa
-- creation Date: 	2008
-- Last Updated: 	0000-00-00
-- Control Number:	xxxx-xxxx-xxxx-xxxx
-- Version: 	0.0
-- Phone : +4915775148443
-- Email: hus244@gmail.com

CREATE OR REPLACE PACKAGE TYPES
AS
   TYPE ref_cursor IS REF CURSOR;
END;
/


CREATE OR REPLACE PACKAGE olap_pkg
AS
----- Defining the dimensions:
   PROCEDURE create_dimension (
      dimension_owner     VARCHAR2,
      dimension_name      VARCHAR2,
      display_name        VARCHAR2,
      plural_name         VARCHAR2,
      short_description   VARCHAR2,
      description         VARCHAR2
   );

----- Defining the hierarchies:
----- Some hierarchies need to be created.
   PROCEDURE create_hierarchy (
      dimension_owner     VARCHAR2,
      dimension_name      VARCHAR2,
      hierarchy_name      VARCHAR2,
      display_name        VARCHAR2,
      short_description   VARCHAR2,
      description         VARCHAR2,
      solved_code         VARCHAR2
   );

------------------------------------------
-- add level to hierarchy
   PROCEDURE add_level_to_hierarchy (
      dimension_owner   VARCHAR2,
      dimension_name    VARCHAR2,
      hierarchy_name    VARCHAR2,
      level_name        VARCHAR2
   );

------------------------------------------
--- Specifying the dimension attributes
   PROCEDURE create_dimension_attribute_2 (
      dimension_owner            VARCHAR2,
      dimension_name             VARCHAR2,
      dimension_attribute_name   VARCHAR2,
      display_name               VARCHAR2,
      short_description          VARCHAR2,
      description                VARCHAR2
   );

------------------------------------------
--- Specifying the level attributes:
   PROCEDURE create_level_attribute_2 (
      dimension_owner            VARCHAR2,
      dimension_name             VARCHAR2,
      dimension_attribute_name   VARCHAR2,
      level_name                 VARCHAR2,
      level_attribute_name       VARCHAR2,
      display_name               VARCHAR2,
      short_description          VARCHAR2,
      description                VARCHAR2
   );

-----------------------------------------
-------- Mapping the levels to columns in the dimension table.
   PROCEDURE map_dimtbl_hierlevel (
      dimension_owner         VARCHAR2,
      dimension_name          VARCHAR2,
      hierarchy_name          VARCHAR2,
      level_name              VARCHAR2,
      owner_dimension_table   VARCHAR2,
      table_name              VARCHAR2,
      column_name             VARCHAR2
   );

-----------------------------------------
--- Finally: creating the cube
   PROCEDURE create_cube (
      cube_owner          VARCHAR2,
      cube_name           VARCHAR2,
      display_name        VARCHAR2,
      short_description   VARCHAR2,
      description         VARCHAR2
   );

-----------------------------------------
-- CREARE MAP hierarchy
   PROCEDURE map_dimtbl_hierlevelattr (
      dimension_owner            VARCHAR2,
      dimension_name             VARCHAR2,
      dimension_attribute_name   VARCHAR2,
      hierarchy_name             VARCHAR2,
      level_name                 VARCHAR2,
      level_attribute_name       VARCHAR2,
      table_owner                VARCHAR2,
      table_name                 VARCHAR2,
      column_name                VARCHAR2
   );

-----------------------------------------
--- Adding dimensions to cube:
   PROCEDURE add_dimension_to_cube (
      cube_owner        VARCHAR2,
      cube_name         VARCHAR2,
      dimension_owner   VARCHAR2,
      dimension_name    VARCHAR2
   );

-----------------------------------------
--- Creating the measure:
   PROCEDURE create_measure (
      cube_owner          VARCHAR2,
      cube_name           VARCHAR2,
      measure_name        VARCHAR2,
      display_name        VARCHAR2,
      short_description   VARCHAR2,
      description         VARCHAR2
   );

------------------------------------------
--- Creating the join relationship between the fact table and the dimension tables:
   PROCEDURE map_facttbl_levelkey (
      cube_owner         VARCHAR2,
      cube_name          VARCHAR2,
      fact_table_owner   VARCHAR2,
      fact_table_name    VARCHAR2,
      store_type         VARCHAR2,
      description        VARCHAR2
   );

-----------------------------------------
---- Validating the cube:
   PROCEDURE validate_cube (cube_owner VARCHAR2, cube_name VARCHAR2);

--------------------------------------------------------
--- clean a cube
  PROCEDURE drop_dimension (dimension_owner VARCHAR2, dimension_name VARCHAR2);
--------------------------------------------------------
--- Lists all cubes in an Oracle instance.
  FUNCTION list_cubes_info RETURN TYPES.ref_cursor;
--------------------------------------------------------
---- then creates an analytic workspace from XML document
procedure create_analytic_workspace;
--------------------------------------------------------
-- Generate a Validation Report 
procedure Generate_Validation_Report;

END olap_pkg;
/

SHOW ERRORS;
-----------------------------------------
-----------------------------------------
-----------------------------------------   
-----------------------------------------   
-----------------------------------------   
-----------------------------------------   
-----------------------------------------   
-----------------------------------------   
-----------------------------------------   
-----------------------------------------   
-----------------------------------------   
-----------------------------------------   
-----------------------------------------   
-----------------------------------------   
-----------------------------------------   
-----------------------------------------   
-----------------------------------------   
-----------------------------------------   
-----------------------------------------   

CREATE OR REPLACE PACKAGE BODY olap_pkg
AS
----- Defining the dimensions:
   PROCEDURE create_dimension (
      dimension_owner     VARCHAR2,
      dimension_name      VARCHAR2,
      display_name        VARCHAR2,
      plural_name         VARCHAR2,
      short_description   VARCHAR2,
      description         VARCHAR2
   )
   AS
   BEGIN
      cwm2_olap_dimension.create_dimension
                                      (dimension_owner,     -- dimension owner
                                       dimension_name,       -- dimension name
                                       display_name,           -- display name
                                       plural_name,             -- plural name
                                       short_description, -- short description
                                       description              -- description
                                      );
   END;

---------------------------------------------------------
   PROCEDURE create_hierarchy (
      dimension_owner     VARCHAR2,
      dimension_name      VARCHAR2,
      hierarchy_name      VARCHAR2,
      display_name        VARCHAR2,
      short_description   VARCHAR2,
      description         VARCHAR2,
      solved_code         VARCHAR2
   )
   AS
   BEGIN
      cwm2_olap_hierarchy.create_hierarchy
         (dimension_owner,
                          -- owner of dimension to which hierarchy is assigned
          dimension_name,  -- name of dimension to which hierarchy is assigned
          hierarchy_name,                                 -- name of hierarchy
          display_name,                                        -- display name
          short_description,                              -- short description
          description,                                          -- description
          solved_code                                           -- solved code
         );
   END;

----------------------------------------------------------
--- add level to hierarchy
   PROCEDURE add_level_to_hierarchy (
      dimension_owner   VARCHAR2,
      dimension_name    VARCHAR2,
      hierarchy_name    VARCHAR2,
      level_name        VARCHAR2
   )
   AS
   BEGIN
      cwm2_olap_level.add_level_to_hierarchy
                                       (dimension_owner, -- owner of dimension
                                        dimension_name,   -- name of dimension
                                        hierarchy_name,   -- name of hierarchy
                                        level_name,           -- name of level
                                        NULL
                                       );                      -- parent level
   END;

----------------------------------------------------------
--- Specifying the dimension attributes
   PROCEDURE create_dimension_attribute_2 (
      dimension_owner            VARCHAR2,
      dimension_name             VARCHAR2,
      dimension_attribute_name   VARCHAR2,
      display_name               VARCHAR2,
      short_description          VARCHAR2,
      description                VARCHAR2
   )
   AS
   BEGIN
      cwm2_olap_dimension_attribute.create_dimension_attribute_2
                     (dimension_owner,                   -- owner of dimension
                      dimension_name,                     -- name of dimension
                      dimension_attribute_name, -- name of dimension attribute
                      display_name,                            -- display name
                      short_description,                  -- short description
                      description,                              -- description
                      1
                     );                                    -- use name as type
   END;

--------------------------------------------------------
--- Specifying the level attributes:
   PROCEDURE create_level_attribute_2 (
      dimension_owner            VARCHAR2,
      dimension_name             VARCHAR2,
      dimension_attribute_name   VARCHAR2,
      level_name                 VARCHAR2,
      level_attribute_name       VARCHAR2,
      display_name               VARCHAR2,
      short_description          VARCHAR2,
      description                VARCHAR2
   )
   AS
   BEGIN
      cwm2_olap_level_attribute.create_level_attribute_2
                     (dimension_owner,                   -- owner of dimension
                      dimension_name,                     -- name of dimension
                      dimension_attribute_name, -- name of dimension attribute
                      level_name,                             -- name of level
                      level_attribute_name,         -- name of level attribute
                      display_name,                            -- display name
                      short_description,                  -- short description
                      description,                              -- description
                      1
                     );                                    -- use name as type
   END;

---------------------------------------------------------
-------- Mapping the levels to columns in the dimension table.
   PROCEDURE map_dimtbl_hierlevel (
      dimension_owner         VARCHAR2,
      dimension_name          VARCHAR2,
      hierarchy_name          VARCHAR2,
      level_name              VARCHAR2,
      owner_dimension_table   VARCHAR2,
      table_name              VARCHAR2,
      column_name             VARCHAR2
   )
   AS
   BEGIN
      cwm2_olap_table_map.map_dimtbl_hierlevel
                           (dimension_owner,                -- dimension owner
                            dimension_name,                  -- dimension name
                            hierarchy_name,               -- name of hierarchy
                            level_name,                       -- name of level
                            owner_dimension_table, -- owner of dimension table
                            table_name,                       -- name of table
                            column_name,                     -- name of column
                            NULL                      -- name of parent column
                           );
   END;

--------------------------------------------------------
--- Finally: creating the cube.
   PROCEDURE create_cube (
      cube_owner          VARCHAR2,
      cube_name           VARCHAR2,
      display_name        VARCHAR2,
      short_description   VARCHAR2,
      description         VARCHAR2
   )
   AS
   BEGIN
      cwm2_olap_cube.create_cube (cube_owner,                    -- cube owner
                                  cube_name,                   -- name of cube
                                  display_name,                -- display name
                                  short_description,      -- short description
                                  description                   -- description
                                 );
   END;

--------------------------------------------------------
-- CREARE MAP hierarchy
   PROCEDURE map_dimtbl_hierlevelattr (
      dimension_owner            VARCHAR2,
      dimension_name             VARCHAR2,
      dimension_attribute_name   VARCHAR2,
      hierarchy_name             VARCHAR2,
      level_name                 VARCHAR2,
      level_attribute_name       VARCHAR2,
      table_owner                VARCHAR2,
      table_name                 VARCHAR2,
      column_name                VARCHAR2
   )
   AS
   BEGIN
      cwm2_olap_table_map.map_dimtbl_hierlevelattr
                     (dimension_owner,                      -- dimension owner
                      dimension_name,                     -- name of dimension
                      dimension_attribute_name, -- name of dimension attribute
                      hierarchy_name,                     -- name of hierarchy
                      level_name,                             -- name of level
                      level_attribute_name,         -- name of level attribute
                      table_owner,                           -- owner of table
                      table_name,                             -- name of table
                      column_name                            -- name of column
                     );
   END;

--------------------------------------------------------
--- Adding dimensions to cube:
   PROCEDURE add_dimension_to_cube (
      cube_owner        VARCHAR2,
      cube_name         VARCHAR2,
      dimension_owner   VARCHAR2,
      dimension_name    VARCHAR2
   )
   AS
   BEGIN
      cwm2_olap_cube.add_dimension_to_cube
                                       (cube_owner,           -- owner of cube
                                        cube_name,             -- name of cube
                                        dimension_owner, -- owner of dimension
                                        dimension_owner   -- name of dimension
                                       );
   END;

--------------------------------------------------------
--- Creating the measure:
   PROCEDURE create_measure (
      cube_owner          VARCHAR2,
      cube_name           VARCHAR2,
      measure_name        VARCHAR2,
      display_name        VARCHAR2,
      short_description   VARCHAR2,
      description         VARCHAR2
   )
   AS
   BEGIN
      cwm2_olap_measure.create_measure
                                      (cube_owner,            -- owner of cube
                                       cube_name,              -- name of cube
                                       measure_name,        -- name of measure
                                       display_name,           -- display name
                                       short_description, -- short description
                                       description              -- description
                                      );
   END;

--------------------------------------------------------
--- Creating the join relationship between the fact table and the dimension tables:
   PROCEDURE map_facttbl_levelkey (
      cube_owner         VARCHAR2,
      cube_name          VARCHAR2,
      fact_table_owner   VARCHAR2,
      fact_table_name    VARCHAR2,
      store_type         VARCHAR2,
      description        VARCHAR2
   )
   AS
   BEGIN
      cwm2_olap_table_map.map_facttbl_levelkey
                                     (cube_owner,             -- owner of cube
                                      cube_name,               -- name of cube
                                      fact_table_owner, -- owner of fact table
                                      fact_table_name,   -- name of fact table
                                      store_type,                -- store type
                                      description               -- description
                                     );
   END;

--------------------------------------------------------
---- Validating the cube:
   PROCEDURE validate_cube (cube_owner VARCHAR2, cube_name VARCHAR2)
   AS
   BEGIN
      cwm2_olap_validate.validate_cube (cube_owner,          -- owner of cube
                                        cube_name             -- name of cube
                                                 );
   END;

--------------------------------------------------------
--- clean a cube
   PROCEDURE drop_dimension (dimension_owner VARCHAR2, dimension_name VARCHAR2)
   AS
   BEGIN
      cwm2_olap_dimension.drop_dimension (dimension_owner,  -- dimension owner
                                          dimension_name     -- dimension name
                                         );
   END;

--------------------------------------------------------
--- Lists all cubes in an Oracle instance.
  FUNCTION list_cubes_info RETURN TYPES.ref_cursor
as
   cr    TYPES.ref_cursor;
   qStr  varchar2(2000);
begin

   qStr := 'select * from ALL_OLAP2_CUBES';

   open cr for qStr;
   return cr;
   close cr;
end;
--------------------------------------------------------
--- then creates an analytic workspace named from XML documet
procedure create_analytic_workspace as
	clb CLOB;
	infile BFILE;
	dname varchar2(500);
BEGIN
	-- Create a temporary clob
	DBMS_LOB.CREATETEMPORARY(clb, TRUE,10);
	-- Create a BFILE use BFILENAME function
	-- Use file GLOBAL.XML in the SCRIPTS directory object.
	infile := BFILENAME('SCRIPTS', 'GLOBAL.XML');
	-- Open the BFILE
	DBMS_LOB.fileopen(infile, dbms_lob.file_readonly);
	-- Load temporary clob from the BFILE
	DBMS_LOB.LOADFROMFILE(clb,infile,DBMS_LOB.LOBMAXSIZE, 1, 1);
	-- Close the BFILE
	DBMS_LOB.fileclose(infile);
	-- Create the GLOBAL analytic workspace
	--DBMS_OUTPUT.PUT_LINE(DBMS_AW_XML.execute(clb));
	DBMS_AW.AW_UPDATE;
	COMMIT;
	-- Free the Temporary Clob
	DBMS_LOB.FREETEMPORARY(clb);
EXCEPTION
	WHEN OTHERS
	THEN
	DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
--------------------------------------------------------
-- Generate a Validation Report 
procedure Generate_Validation_Report as
begin
	/*cwm2_olap_manager.set_echo_on;
	cwm2_olap_manager.begin_log('/users/myxademo/myscripts' , 'x.log');

	cwm2_olap_validate.validate_dimension('xademo','product','default','yes');

	cwm2_olap_manager.end_log;
	cwm2_olap_manager.set_echo_off;*/
        commit;

end;

END olap_pkg;
/

SHOW ERROR;
