#!/bin/bash
# Database credentials
user="admin"
password="Password"
host="10.10.10.31"
port="3306"
db_name="vydehiHMS_QA"
date=$(date +"%d%m%Y%H%M")
# Other options
#backup_path="/DB/DB_Backup"
# Execute MySQL queries before backup
mysql --user=$user --password=$password --host=$host --port=$port --execute="SET SESSION MAX_EXECUTION_TIME=0; SET GLOBAL MAX_EXECUTION_TIME=0; SET MAX_EXECUTION_TIME=0;"
# Record start time
start_time=$(date +%s)
# Dump database into SQL file
mysqldump --user=$user --password=$password --host=$host --port=$port --default-character-set=utf8 --protocol=tcp --column-statistics=FALSE --single-transaction=TRUE --routines --events $db_name >/opt/backup/vims/$db_name-$date.sql
# Record end time
end_time=$(date +%s)
# Calculate execution time
execution_time=$((end_time - start_time))
# Print execution time
echo "Backup started at: $start_time"
echo "Backup finished at: $end_time"
echo "Execution time: $execution_time seconds"
# Sleep for 6000 seconds (10 minutes)
sleep 6
# Execute MySQL queries after backup
mysql --user=$user --password=$password --host=$host --port=$port --execute="SET SESSION MAX_EXECUTION_TIME=90000; SET GLOBAL MAX_EXECUTION_TIME=90000; SET MAX_EXECUTION_TIME=90000;"
# Create zip
zip -r /opt/backup/vims/$db_name-$date.zip /opt/backup/vims/$db_name-$date.sql
# Delete SQL file
rm /opt/backup/vims/$db_name-$date.sql
# Delete files older than 30 days
find /opt/backup/vims/ -mtime +30 -exec rm {} \;
# DB backup log
echo -e "$(date +'%d-%b-%y  %r '): ALERT: Database has been Backuped" >>/opt/backup/DB_Backup.log
