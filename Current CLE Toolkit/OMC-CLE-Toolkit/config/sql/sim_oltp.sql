-- ## Disclaimer:
-- ## "All scripts and data files provided in this workshop were written by the presenter 
-- ## for the purposes of the workshop and are not to be used outside of the workshop.  
-- ## Oracle will not take any responsibility for its use outside of the workshop."

-- ## Discription:
-- ## This script is meant to emulate a transaction processing job that would be
-- ## realistically submitted in a business deadling with sales or something. 

-- ## Author:
-- ## Zachary Hamilton
-- ## zach.hamilton@oracle.com

-- ## BEGIN SCRIPT BODY
-- ##
-- OLTP SIMULATION --
 declare
	--selectors
	v_terr_selector number(1);
	v_prod_selector number(1);
	--types
	type va_territories is varray (5) of varchar2(15);
	type va_products    is varray (5) of varchar2(25);
	--arrays
	v_territories va_territories := va_territories('Northern', 'Southern', 'Central', 'Western', 'Eastern');
	v_products    va_products    := va_products   ('GT', 'DR', 'BA', 'KB', 'MC');
	--shared props
	v_trans_id char(32);
	v_rightnow timestamp;
	--territory props
	v_terr_id   varchar2(2);
	v_terr_name varchar2(15);
	--product props
	v_prod_id    varchar2(2);
	v_prod_quant number(1);
	--order props
	v_order_id  char(32);
	v_order_amt number(5);
	--salesperson props
	v_sp_id   number(5);
	v_sp_name varchar2(10);
	v_sp_dbusr varchar2(10);
	--
 begin
    --define shared props
    select current_timestamp into v_rightnow from dual;
    select sys_guid() into v_trans_id from dual;
    --define product props
    select dbms_random.value(1, 5) into v_prod_selector from dual;
    v_prod_id := v_products(v_prod_selector);
    select dbms_random.value(1, 9) into v_prod_quant from dual;
    --define order props
    select sys_guid() into v_order_id from dual;
    select prod_price * v_prod_quant into v_order_amt from products where prod_id = v_prod_id;	
    --define territory props
    select dbms_random.value(1, 5) into v_terr_selector from dual;
    v_terr_name := v_territories(v_terr_selector);
    select terr_id into v_terr_id from territories where terr_name = v_terr_name; 
    --define salesperson props
    select sys_context('userenv', 'session_user') into v_sp_dbusr from dual;
    select sp_id into v_sp_id from salespeople where sp_dbuser = v_sp_dbusr;
    select sp_name into v_sp_name from salespeople where sp_dbuser = v_sp_dbusr;
    --insert values into tables
    insert into sales_by_product     (trans_time, trans_id, prod_id, prod_quant) values (v_rightnow, v_trans_id, v_prod_id, v_prod_quant);
    insert into sales_by_orders      (trans_time, trans_id, order_id, order_amt) values (v_rightnow, v_trans_id, v_order_id, v_order_amt);
    insert into sales_by_territory   (trans_time, trans_id, terr_id, terr_name)  values (v_rightnow, v_trans_id, v_terr_id, v_terr_name);
    insert into sales_by_salesperson (trans_time, trans_id, sp_id, sp_name)      values (v_rightnow, v_trans_id, v_sp_id, v_sp_name);
    --
    commit;
end;
-- ##
-- ## END SCRIPT BODY

 