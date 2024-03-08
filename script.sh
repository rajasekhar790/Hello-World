#!/bin/bash

DATABASE=$1
OUTPUT_FILE="table_info_${DATABASE}.txt"

if [ -z "$DATABASE" ]; then
  echo "Usage: $0 <database_name>"
  exit 1
fi

# Hive/Beeline command to get table details. Adjust according to your Hive setup
beeline -u 'jdbc:hive2://your_hive_server:10000' -n your_username -p your_password --silent=true -e "USE $DATABASE; SHOW TABLES;" | while read TABLE; do
  TABLE_TYPE=$(beeline -u 'jdbc:hive2://your_hive_server:10000' -n your_username -p your_password --silent=true -e "USE $DATABASE; DESCRIBE FORMATTED $TABLE;" | grep -o 'Table Type:.*' | cut -d' ' -f3)
  HDFS_PATH=$(beeline -u 'jdbc:hive2://your_hive_server:10000' -n your_username -p your_password --silent=true -e "USE $DATABASE; DESCRIBE FORMATTED $TABLE;" | grep 'Location:' | awk '{print $2}')
  echo "$DATABASE,$TABLE,$TABLE_TYPE,$HDFS_PATH" >> $OUTPUT_FILE
done