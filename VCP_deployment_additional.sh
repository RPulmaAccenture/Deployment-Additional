#!/bin/bash
echo "Enter Username:"
read username
echo "Enter Password:"
read password


home=/home/nbtydata
top=$XXNBTY_TOP
bin_fndcpesr=/u01/oracle/apps/apps_st/appl/fnd/12.0.0/bin/fndcpesr


#executing all SQL files
sqlplus -s $username/$password <<eof

spool VCP_deployment_additional.log

prompt Executing all packages
prompt 
prompt Executing script XXNBTY_MSC_EXT02_CUSTOMER_PKG.pkb
	@$top/admin/sql/XXNBTY_MSC_EXT02_CUSTOMER_PKG.pkb
prompt Executing script XXNBTY_MSC_EXT01_ITEM_DESC_PKG.pkb
	@$top/admin/sql/XXNBTY_MSC_EXT01_ITEM_DESC_PKG.pkb	
spool off
eof

#uploading all FND files
echo "Uploading all FND files" >> $home/VCP_RICEFW/VCP_deployment_additional.log
echo "" >> $home/VCP_RICEFW/VCP_deployment_additional.log
	
cd $top/admin/import
echo "" >> $home/VCP_RICEFW/VCP_deployment_additional.log	
	
#function to upload data definition
function upload_dd(){
	echo "Uploading $1..." >> $home/VCP_RICEFW/VCP_deployment_additional.log
	FNDLOAD $username/$password 0 Y UPLOAD $XDO_TOP/patch/115/import/xdotmpl.lct $1 CUSTOM_MODE=FORCE >> $home/VCP_RICEFW/VCP_deployment_additional.log 2>&1
}
	
#function to upload MENU
function upload_menu(){
	echo "Uploading $1..." >> $home/VCP_RICEFW/VCP_deployment_additional.log
	FNDLOAD $username/$password 0 Y UPLOAD $FND_TOP/patch/115/import/afsload.lct $1 CUSTOM_MODE=FORCE >> $home/VCP_RICEFW/VCP_deployment_additional.log 2>&1	
}

#function to upload Responsibility
function upload_resp(){
	echo "Uploading $1..." >> $home/VCP_RICEFW/VCP_deployment_additional.log
	FNDLOAD $username/$password O Y UPLOAD $FND_TOP/patch/115/import/afscursp.lct $1 CUSTOM_MODE=FORCE >> $home/VCP_RICEFW/VCP_deployment_additional.log 2>&1
}

#function to upload concurrent program
function upload_cp(){
	echo "Uploading $1..." >> $home/VCP_RICEFW/VCP_batch_deployment.log
	FNDLOAD $username/$password 0 Y UPLOAD $FND_TOP/patch/115/import/afcpprog.lct $1 CUSTOM_MODE=FORCE >> $home/VCP_RICEFW/VCP_deployment_additional.log 2>&1
}

#function to upload request set
function upload_rs(){
	echo "Uploading $1..." >> $home/VCP_RICEFW/VCP_batch_deployment.log
	FNDLOAD $username/$password 0 Y UPLOAD $FND_TOP/patch/115/import/afcprset.lct $1 CUSTOM_MODE=FORCE >> $home/VCP_RICEFW/VCP_batch_deployment.log 2>&1
}

#function to upload request set links
function upload_rsl(){
	echo "Uploading $1..." >> $home/VCP_RICEFW/VCP_batch_deployment.log
	FNDLOAD $username/$password 0 Y UPLOAD $FND_TOP/patch/115/import/afcprset.lct $1 CUSTOM_MODE=FORCE >> $home/VCP_RICEFW/VCP_batch_deployment.log 2>&1
}

#function to upload request set group
function upload_rsg(){
	echo "Uploading $1..." >> $home/VCP_RICEFW/VCP_batch_deployment.log
	FNDLOAD $username/$password 0 Y UPLOAD $FND_TOP/patch/115/import/afcpreqg.lct $1 CUSTOM_MODE=FORCE >> $home/VCP_RICEFW/VCP_deployment_additional.log 2>&1
}


echo "Uploading Data definition" >> $home/VCP_RICEFW/VCP_deployment_additional.log
upload_dd XXNBTY_EXT05_DD.ldt

echo "" >> $home/VCP_RICEFW/VCP_deployment_additional.log

echo "Uploading VCP Menu" >> $home/VCP_RICEFW/VCP_deployment_additional.log
upload_menu XXNBTY_MSC_SCP_TOP_4.0.ldt
upload_menu MSC_SCA_TOP_4.0.ldt
upload_menu XXNBTY_ASCP_IOADMINUSER.ldt
upload_menu XXNBTY_INVENTORY_PLANNER.ldt
upload_menu XXNBTY_PLANNING_ADMIN.ldt
upload_menu MSC_TOP_4.0.ldt

echo "" >> $home/VCP_RICEFW/VCP_deployment_additional.log

echo "Uploading VCP Responsibility" >> $home/VCP_RICEFW/VCP_deployment_additional.log
upload_resp NBTYAPCCSSManager.ldt
upload_resp NBTY_APCC_Supply_User.ldt
upload_resp NBTY_ASCP_IOAdminUser.ldt
upload_resp NBTY_Inventory_Planner.ldt
upload_resp NBTY_Planning_Admin.ldt
upload_resp NBTY_Supply_Planner.ldt
upload_resp NBTY_APCC_Supply_Admin_User.ldt

echo "" >> $home/VCP_RICEFW/VCP_deployment_additional.log

echo "Uploading EXT05 concurrent program" >> $home/VCP_RICEFW/VCP_deployment_additional.log
upload_cp XXNBTY_EXT05_CP_d.ldt

echo "" >> $home/VCP_RICEFW/VCP_deployment_additional.log

echo "Uploading EXT05 concurrent program request group" >> $home/VCP_RICEFW/VCP_deployment_additional.log
upload_rsg XXNBTY_EXT05_CP_RG.ldt

echo "" >> $home/VCP_RICEFW/VCP_deployment_additional.log

echo "Uploading LF19 Request set links" >> $home/VCP_RICEFW/VCP_deployment_additional.log
upload_rsl XXNBTY_LF19_RSL.ldt

echo "" >> $home/VCP_RICEFW/VCP_deployment_additional.log

echo "Uploading Sanjay Request Set" >> $home/VCP_RICEFW/VCP_deployment_additional.log
upload_rs XXNBTY_Planning_MPS_MRP_RS.ldt
upload_rsl XXNBTY_Planning_MPS_MRP_RL.ldt
upload_rsg XXNBTY_Planning_MPS_MRP_RG.ldt

upload_rs XXNBTYMONTHMPS_RS.ldt
upload_rsl XXNBTYMONTHMPS_RL.ldt
upload_rsg XXNBTYMONTHMPS_RG.ldt

upload_rs XXNBTY_MONTHLY_PLAN_RS.ldt
upload_rsl XXNBTY_MONTHLY_PLAN_RL.ldt
upload_rsg XXNBTY_MONTHLY_PLAN_RG.ldt

echo "" >> $home/VCP_RICEFW/VCP_deployment_additional.log