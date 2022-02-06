#!/bin/bash

# start ssh server
/etc/init.d/ssh start

# format namenode
$HADOOP_HOME/bin/hdfs namenode -format

# start hadoop
$HADOOP_HOME/sbin/start-dfs.sh
$HADOOP_HOME/sbin/start-yarn.sh
$HADOOP_HOME/sbin/mr-jobhistory-daemon.sh start historyserver

# Create data directory to store the csv file
$HADOOP_HOME/bin/hdfs dfs -mkdir -p /opt/data/hdfs/raw
$HADOOP_HOME/bin/hdfs dfs -chmod g+w /opt/data/hdfs/raw

# Copy default hive configuration
cp ${HIVE_HOME}/hive-default.xml.template ${HIVE_HOME}/hive-site.xml

# Initiate derby database
$HIVE_HOME/bin/schematool -dbType derby -initSchema

# keep container running
tail -f /dev/null