-- ## Disclaimer:
-- ## "All scripts and data files provided in this workshop were written by the presenter 
-- ## for the purposes of the workshop and are not to be used outside of the workshop.  
-- ## Oracle will not take any responsibility for its use outside of the workshop."

-- ## Discription:
-- ## This script is meant to set up the users in the database and grant them the 
-- ## correct permissions. 

-- ## Author:
-- ## Zachary Hamilton
-- ## zach.hamilton@oracle.com

-- ## BEGIN SCRIPT BODY
-- ##
declare
    --types
	type va_users is varray(8) of varchar2(10);
	--arrays
    v_users va_users := va_users('emma', 'olivia', 'ava', 'liam', 'mason', 'logan', 'avery', 'carter');
	--shared
    i_user varchar2(10);

begin	
	for i in 1 .. v_users.count loop
		i_user := v_users(i);
		execute immediate 'create user '||i_user||' identified by password';
		execute immediate 'grant create session to '||i_user||'';
        execute immediate 'grant create synonym to '||i_user||'';
		for elem in (select * from user_tables) loop
			execute immediate 'grant select, insert on '||elem.table_name||' to '||i_user||'';
		end loop;
	end loop;
    for elem in (select * from user_tables) loop
        execute immediate 'create or replace public synonym '||elem.table_name||' for c##simulation.'||elem.table_name||'';    
    end loop;
end;
-- ##
-- ## END SCRIPT BODY