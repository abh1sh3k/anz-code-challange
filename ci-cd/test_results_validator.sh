#!/bin/sh

# storing path provided by user
RESULT_PATH=$1

# exit script if input not provided by user
if [ $# -eq 0 ]; then
	echo "Please provide result xml path"
	exit 1
fi

OUTPUT_FILE="${RESULT_PATH}/*.xml"

# get for FAIL keyword
CHECK_FAILURE=`grep "FAIL" ${OUTPUT_FILE}`

# check if fail keyword was found then exit with 1 else 0
if [ -z "${CHECK_FAILURE}" ]; then
	echo "exit 0"
	exit 0
else
	echo "exit 1"
	exit 1
fi
