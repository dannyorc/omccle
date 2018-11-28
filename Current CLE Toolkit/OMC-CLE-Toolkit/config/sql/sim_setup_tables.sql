-- ## Disclaimer:
-- ## "All scripts and data files provided in this workshop were written by the presenter 
-- ## for the purposes of the workshop and are not to be used outside of the workshop.  
-- ## Oracle will not take any responsibility for its use outside of the workshop."

-- ## Discription:
-- ## This script sets up the tables to be used in the database throughout the runtime.

-- ## Author:
-- ## Zachary Hamilton
-- ## zach.hamilton@oracle.com

-- ## BEGIN SCRIPT BODY
-- ##
create table sales_by_product (
	trans_time timestamp,
	trans_id   char(32), 
	prod_id	   varchar2(2),
	prod_quant number(2),
	primary key (trans_id)
	using index
);
create table sales_by_orders (
	trans_time timestamp, 
	trans_id   char(32), 
	order_id   char(32),
	order_amt  number(5),
	primary key (trans_id)
	using index
);
create table sales_by_territory (
	trans_time timestamp, 
	trans_id   char(32), 
	terr_id    varchar2(2),
	terr_name  varchar2(15), 
	primary key (trans_id)
	using index
);
create table sales_by_salesperson (
	trans_time   timestamp, 
	trans_id     char(32), 
	sp_id        number(5), 
	sp_name      varchar(10), 
	primary key (trans_id)
	using index
);
--####### "OLAP TABLES" #######--
create table territory_report (
	report_time timestamp, 
	terr_id     varchar2(2), 
	terr_name   varchar2(15), 
	terr_rev    number(38)
);
create table salesperson_report (
	report_time timestamp,
	sp_id       number(5), 
	sp_name     varchar2(10),
	sp_rev      number(28)
);
create table product_report (
	report_time timestamp, 
	prod_id     varchar2(2),
	prod_name   varchar2(25),
	prod_rev    number(28)
);
--####### "REFERENCE TABLES" #######--
create table territories (
	terr_id   varchar2(2), 
	terr_name varchar2(15),
	primary key (terr_id)
	using index
);
create table salespeople (
	sp_id 	  number(5), 
	sp_name   varchar2(10),
	sp_dbuser varchar2(25),
	primary key (sp_id)
	using index
);
create table products (
	prod_id    varchar2(2), 
	prod_name  varchar2(25),
	prod_price number(3),
	primary key (prod_id)
	using index
);
-- ##
-- ## END SCRIPT BODY

	
	
	
	
	