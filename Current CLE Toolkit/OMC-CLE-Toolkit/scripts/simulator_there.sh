#!/bin/bash 

## Disclaimer:
## "All scripts and data files provided in this workshop were written by the presenter 
## for the purposes of the workshop and are not to be used outside of the workshop.  
## Oracle will not take any responsibility for its use outside of the workshop."

## Discription:
## This script does a bunch of things. There is a open while loop used as a timer
## at the base of the life of the operation. During that runtime, a sine function
## flucuates a rate of transactions that are submitted for completion in batches. 
## Once every 15 or 30 minutes, an anomalous action will happen, in which some
## interaction meant to represent malicious activity will happen. The loop is meant
## to trend up slowly over time. 

## Author:
## Zachary Hamilton
## zach.hamilton@oracle.com

## BEGIN SCRIPT BODY
##
echo "####Simulation: working on remote machine...####"
cd config/sql
chmod a+x *.*
if [ ! -e did ]; then
	echo "####Simulation: begining to set up database components...####" >> output
	sqlplus / as sysdba <<-EOF
		create user c##simulation identified by adminpassword;
		grant dba to c##simulation container=all;
		commit;
		exit;
	EOF
	sqlplus c##simulation/adminpassword@pdb1 <<-EOF
		@sim_setup_tables.sql
		commit;
		@sim_setup_ref.sql
		commit;
		@sim_setup_users.sql
		/
		commit;
		exit;
	EOF
	echo "####Simulation: created database users and tables...####" >> output
	echo "sqlsetup" > did
fi
salespeople=('emma' 'olivia' 'ava' 'liam' 'mason' 'logan');
analysts=('avery' 'carter');
echo "Simulation: beggining to loop for a while..." 
echo "<$(date)> Simulation: begining to loop for a while!" >> output
end=$((SECONDS+14400))
pi=`echo "4*a(1)" | bc -l`
index=0
rate=40
trend=40
oltp_switch=true
olap_switch=true
echo "####Getting started with new run-through####" >> output
while [ $SECONDS -lt $end ]; do	
	if ! (($SECONDS % 300)); then
		v=`echo "$index/2" | bc -l`
		f=`echo "20*s($v*$pi)+$trend" | bc -l`
		rate=`echo "($f+0.5)/1" | bc`
		((index++))
		((trend+=15))
	fi
	
	if ! (($SECONDS % 60)) && [ $oltp_switch = "true" ]; then
		for ((i=0;i<$rate;i++)); do
			random_sp=${salespeople[$RANDOM % ${#salespeople[@]} ]};
			sqlplus $random_sp/password@pdb1 > /dev/null 2>&1 <<-EOF &
				@sim_oltp.sql
				/
				commit;
				exit;
			EOF
			pids[${i}]=$!
		done
		echo "<$(date)> Submitted a set of $rate OLTP jobs, waiting..." >> output
		for pid in ${pids[*]}; do
			wait $pid
		done
		oltp_switch=false
	fi
	if ! (($SECONDS % 300)) && [ $olap_switch = "true" ]; then
		random_an=${analysts[$RANDOM % ${#analysts[@]} ]};
		sqlplus $random_an/password@pdb1 > /dev/null 2>&1 <<-EOF &
			@sim_olap.sql
			/
			commit;
			exit;
		EOF
		echo "<$(date)> Submitted a new of OLAP job, waiting..." >> output
		wait $!
		olap_switch=false
	fi
	if [ $((($SECONDS % 60))) -gt 0 ]; then
		oltp_switch=true
	fi
	if [ $((($SECONDS & 60))) -gt 0 ]; then
		olap_switch=true
	fi
	if ! (($SECONDS % 1800)); then
		random_sp=${salespeople[$RANDOM % ${#salespeople[@]} ]};
		echo "<$(date)> $random_sp is trying to drop orders table 50 times..." >> output
		for ((i=0;i<50;i++)); do
			sqlplus $random_sp/password@pdb1 > /dev/null 2>&1 <<-EOF &
				drop table c##simulation.sales_by_orders;
				exit;
			EOF
		done
	fi
	# if ! (($SECONDS % 900)); then
		# echo "<$(date)> Someone is trying to elevate oracle to root..." >> output
		# for ((i=0;i<50;i++)); do
			# cd /root
		# done
	# fi
done
exit
## 
## END SCRIPT BODY