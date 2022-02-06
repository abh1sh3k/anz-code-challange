import argparse
import sys
import configparser
import json
from pyspark.sql import SparkSession 
from pyspark.sql.functions import *

# Parse the arguments
parser = argparse.ArgumentParser()
parser.add_argument('--schema', dest='schema', type=str, help='Path of schema file in json format')
parser.add_argument('--data', dest='data', type=str, help='Path of data file in csv format')
parser.add_argument('--tag', dest='tag', type=str, help='Path of tag file')
parser.add_argument('--outputTableName', dest='outputTableName', type=str, help='Output table name for Hive')

args = parser.parse_args()

# Read config file to get host and port details
config = configparser.ConfigParser()
config.read('config.cfg')
HADOOP_URL =  config['HADOOP CONFIG']['HADOOP_URL']
SPARK_HOST = config['HADOOP CONFIG']['SPARK_HOST']
SPARK_PORT = config['HADOOP CONFIG']['SPARK_PORT']

# Open tag file and get the content
tag_file = open(args.tag,"r")
line_content = tag_file.readline()

#Create spark session
spark = SparkSession.builder.appName("anz-code-challenge").master("yarn") \
         .config("spark.driver.host", SPARK_HOST) \
         .config("spark.driver.port", SPARK_PORT) \
         .enableHiveSupport() \
         .getOrCreate()

data_file = spark.read.option("header", True).csv(args.data)

# Validate the data file name passed in argument is matched with the name mentioned in tag file
if line_content.split("|")[0] != args.data.split("/")[-1]:
   sys.exit(2)
# Validate the count mentioned in tag file matches with records available in data file
elif line_content.split("|")[1] != data_file.count():
   sys.exit(1)
# Load data to hive table 
elif (line_content.split("|")[0] == args.data.split("/")[-1]) and (line_content.split("|")[1] == data_file.count()):
   # Put csv in hdfs
   data_file.write.csv(HADOOP_URL + "/opt/data/hdfs/raw/" + args.data.split("/")[-1])

   # Read json schema file and create the hive table
   with open(args.schema) as schema_file:
      schema_data = json.load(schema_file)

   # Create hive table schema from json
   table_schema = "CREATE TABLE IF NOT EXISTS " + args.outputTableName + \
                  " (" + ", ".join(str(item['name'] + ' ' + item['type']) \
                  for item in schema_data['columns']) + ", primary key(" + ", ".join(str(item) \
                  for item in schema_data['primary_keys']) + ");"

   # Load csv data from hdfs to hive table
   spark.sql("LOAD DATA " + HADOOP_URL + "/opt/data/hdfs/raw/" + args.data.split("/")[-1] + "INTO TABLE" + args.outputTableName)
else:
   sys.exit(1)
   
