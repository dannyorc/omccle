-- ## Disclaimer:
-- ## "All scripts and data files provided in this workshop were written by the presenter 
-- ## for the purposes of the workshop and are not to be used outside of the workshop.  
-- ## Oracle will not take any responsibility for its use outside of the workshop."

-- ## Discription:
-- ## This is a utility sometimes, when you need to clean up the data. Not used it runtime, 
-- ## but readily available.

-- ## Author:
-- ## Zachary Hamilton
-- ## zach.hamilton@oracle.com

-- ## BEGIN SCRIPT BODY
-- ##
drop user c##simulation cascade;
drop user emma cascade;
drop user olivia cascade;
drop user ava cascade;
drop user liam cascade; 
drop user mason cascade;
drop user logan cascade; 
drop user avery cascade;
drop user carter cascade;

drop table SALES_BY_ORDERS;
drop table SALES_BY_TERRITORY;
drop table SALES_BY_SALESPERSON;
drop table TERRITORIES;
drop table SALESPEOPLE;
drop table PRODUCTS;
drop table SALES_BY_PRODUCT;
drop table TERRITORY_REPORT;
drop table SALESPERSON_REPORT;
drop table PRODUCT_REPORT;

drop public synonym SALES_BY_ORDERS;
drop public synonym SALES_BY_TERRITORY;
drop public synonym SALES_BY_SALESPERSON;
drop public synonym TERRITORIES;
drop public synonym SALESPEOPLE;
drop public synonym PRODUCTS;
drop public synonym SALES_BY_PRODUCT;
drop public synonym TERRITORY_REPORT;
drop public synonym SALESPERSON_REPORT;
drop public synonym PRODUCT_REPORT;

--truncate table SALES_BY_ORDERS;
--truncate table SALES_BY_TERRITORY;
--truncate table SALES_BY_SALESPERSON;
--truncate table SALES_BY_PRODUCT;
----truncate table TERRITORIES;
----truncate table SALESPEOPLE;
----truncate table PRODUCTS;
--truncate table TERRITORY_REPORT;
--truncate table SALESPERSON_REPORT;
--truncate table PRODUCT_REPORT;
-- ##
-- ## END SCRIPT BODY