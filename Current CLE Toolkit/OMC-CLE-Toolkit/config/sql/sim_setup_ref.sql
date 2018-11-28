-- ## Disclaimer:
-- ## "All scripts and data files provided in this workshop were written by the presenter 
-- ## for the purposes of the workshop and are not to be used outside of the workshop.  
-- ## Oracle will not take any responsibility for its use outside of the workshop."

-- ## Discription:
-- ## Some tables need to have data in them before the OLTP or OLAP jobs will
-- ## work correctly. This script populates that data. 

-- ## Author:
-- ## Zachary Hamilton
-- ## zach.hamilton@oracle.com

-- ## BEGIN SCRIPT BODY
-- ##
--## SCRIPT FOR SETTING UP THE REFERENCE TABLES WITH VALUES ##--
--'Emma','Olivia', 'Ava', 'Liam', 'Mason', 'Logan'
--## SETUP SALESPEOPLE REFERENCE TABLE ##--
insert into salespeople (sp_id, sp_name, sp_dbuser) values (13579, 'Emma',   'EMMA');
insert into salespeople (sp_id, sp_name, sp_dbuser) values (24680, 'Olivia', 'OLIVIA');
insert into salespeople (sp_id, sp_name, sp_dbuser) values (12590, 'Ava',    'AVA');
insert into salespeople (sp_id, sp_name, sp_dbuser) values (97531, 'Liam',   'LIAM');
insert into salespeople (sp_id, sp_name, sp_dbuser) values (98642, 'Mason',  'MASON');
insert into salespeople (sp_id, sp_name, sp_dbuser) values (99621, 'Logan',  'LOGAN');
--## SETUP TERRITORIES REFERENCE TALBE ##--
--## IDs: NO, SO, CT, WE, EA
insert into territories (terr_id, terr_name) values ('NO', 'Northern'); 
insert into territories (terr_id, terr_name) values ('SO', 'Southern');
insert into territories (terr_id, terr_name) values ('CT', 'Central');
insert into territories (terr_id, terr_name) values ('WE', 'Western');
insert into territories (terr_id, terr_name) values ('EA', 'Eastern');
--## SETUP PRODUCTS REFERENCE TABLE ##--
--## IDs: GT, DR, BA, KB, MC
insert into products (prod_id, prod_name, prod_price) values ('GT', 'Guitar', 50);
insert into products (prod_id, prod_name, prod_price) values ('DR', 'Drum', 75);
insert into products (prod_id, prod_name, prod_price) values ('BA', 'Bass', 40);
insert into products (prod_id, prod_name, prod_price) values ('KB', 'Keyboard', 65);
insert into products (prod_id, prod_name, prod_price) values ('MC', 'Microphone', 25);
-- ##
-- ## END SCRIPT BODY