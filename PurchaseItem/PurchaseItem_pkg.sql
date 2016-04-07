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


CREATE OR REPLACE PACKAGE Mof_PurchaseItem_pkg
AS

--------------------------------------------------------
--- Lists all cubes in an Oracle instance.
  FUNCTION sp_getPurchaseItem   RETURN TYPES.ref_cursor;
--------------------------------------------------------

END Mof_PurchaseItem_pkg;
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
CREATE OR REPLACE PACKAGE BODY Mof_PurchaseItem_pkg  AS

FUNCTION sp_getPurchaseItem  RETURN TYPES.ref_cursor
as
   cr    TYPES.ref_cursor;
   qStr  varchar2(2000);
begin

   qStr := 
         'select purch_vw.itemid itemID,itm.item_name_en itemNameEn, itm.item_name_ar itemNameAr,' ||
         'vdr.company_name_en companyNameEn, ' ||
         'vdr.company_name_ar companyNameAr, ' ||
         'purch_vw.sumAmount Amount, ' ||
         'purch_vw.sumQuantity Quantity ' ||
         'from PurchaseItem_View purch_vw, items itm,vendors vdr ' ||
         'where  purch_vw.itemid= itm.item_id ' ||
         'and    purch_vw.vendorID = vdr.vendor_id ' ;


   open cr for qStr;
   return cr;
   close cr;
end;

END Mof_PurchaseItem_pkg;
/

SHOW ERROR;



