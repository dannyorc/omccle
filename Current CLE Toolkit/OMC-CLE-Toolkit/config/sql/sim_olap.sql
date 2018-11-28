-- ## Disclaimer:
-- ## "All scripts and data files provided in this workshop were written by the presenter 
-- ## for the purposes of the workshop and are not to be used outside of the workshop.  
-- ## Oracle will not take any responsibility for its use outside of the workshop."

-- ## Discription:
-- ## This script is meant to act like a typical job submitted by an analyst in
-- ## order to do some table joins and counts and sums and then report the data. 

-- ## Author:
-- ## Zachary Hamilton
-- ## zach.hamilton@oracle.com

-- ## BEGIN SCRIPT BODY
-- ##
-- OLAP SIMULATION --
declare
	--types
	type va_territories is varray (5) of varchar2(2);
	type va_products    is varray (5) of varchar2(2);
	type va_salespeople is varray (6) of number(5);
	--arrays
	v_territories va_territories := va_territories('NO', 'SO', 'CT', 'WE', 'EA');
	v_products    va_products    := va_products   ('GT', 'DR', 'BA', 'KB', 'MC');
	v_salespeople va_salespeople := va_salespeople(13579, 24680, 12590, 97531, 98642, 99621);
	--shared props
	v_rightnow timestamp;
	
	--territory report props
	i_terr_id   varchar2(2);
	i_terr_name varchar2(15);
	i_terr_rev  number(38);
    tc          number(38);
	--salesperson report props
	i_sp_id   number(5);
	i_sp_name varchar2(10);
	i_sp_rev  number(38);
    sc        number(38);
	--product report props
	i_prod_id   varchar2(2);
	i_prod_name varchar2(25);
	i_prod_rev  number(38);
    pc          number(38);
	
begin
	select current_timestamp into v_rightnow from dual;
	for i in 1 .. v_territories.count loop
		i_terr_id := v_territories(i);
		select terr_name into i_terr_name from territories where terr_id = i_terr_id;
        select count(terr_id) into tc from sales_by_territory where terr_id = i_terr_id;
        if (tc > 0) then
            select sum(order_amt) into i_terr_rev
            from sales_by_orders sbo, sales_by_territory sbt
            where sbo.trans_id = sbt.trans_id
            and sbt.terr_id = i_terr_id;
            insert into territory_report values (v_rightnow, i_terr_id, i_terr_name, i_terr_rev);
        else
            insert into territory_report values (v_rightnow, i_terr_id, i_terr_name, 0);
        end if;
	end loop;
	for i in 1 .. v_salespeople.count loop
		i_sp_id := v_salespeople(i);
		select sp_name into i_sp_name from salespeople where sp_id = i_sp_id;
        select count(sp_id) into sc from sales_by_salesperson where sp_id = i_sp_id;
        if (sc > 0) then
            select sum(order_amt) into i_sp_rev
            from sales_by_orders sbo, sales_by_salesperson sbs
            where sbo.trans_id = sbs.trans_id
            and sbs.sp_id = i_sp_id;
            insert into salesperson_report values (v_rightnow, i_sp_id, i_sp_name, i_sp_rev);
        else
            insert into salesperson_report values (v_rightnow, i_sp_id, i_sp_name, 0);
        end if;
	end loop;
	for i in 1 .. v_products.count loop
		i_prod_id := v_products(i);
		select prod_name into i_prod_name from products where prod_id = i_prod_id;
        select count(prod_id) into pc from sales_by_product where prod_id = i_prod_id;
        if (pc > 0) then
            select sum(order_amt) into i_prod_rev
            from sales_by_orders sbo, sales_by_product sbp
            where sbo.trans_id = sbp.trans_id
            and sbp.prod_id = i_prod_id;
            insert into product_report values (v_rightnow, i_prod_id, i_prod_name, i_prod_rev);
        else
            insert into product_report values (v_rightnow, i_prod_id, i_prod_name, 0);
        end if;
	end loop;
    commit;
end;
-- ##
-- ## END SCRIPT BODY