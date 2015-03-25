#!/bin/bash
echo "Enter Password for XXNBTY user:"
read password

home=/home/nbtydata
top=$XXNBTY_TOP


#executing GRANT command for all VCP custom staging tables.
sqlplus -s xxnbty/$password <<eof
spool VCP_grant.log

prompt Executing the script for GRANT command for all VCP custom staging tables.
	@$top/sql/xxnbty_vcp_grant_command_all_tables.sql
spool off
eof
echo "" >> VCP_grant.log