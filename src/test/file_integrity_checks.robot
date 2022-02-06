*** Settings ***
Library    Process

*** Test Cases ***

TC-01 All checks are successful
    ${return}=    run process   python3 anz-code-challenge.py --schema scenarios/aus-capitals.json --data scenarios/aus-capitals.csv --tag scenarios/aus-capitals.tag --outputTableName sample.aus-capitals
    ${fileName}=    run process docker exec -it hdfs-hive hdfs fs -ls /opt/data/hdfs/raw/aus-capitals.csv
    IF    ${fileName} == "aus-capitals.csv" && ${sqlOutput} != 
        Pass Execution
    END
    ${sqlOutput}=   run process docker exec -it hdfs-hive hive -e "select * from sample.aus-capitals"
    IF    ${sqlOutput} != ""
        Pass Execution
    END

TC-02 Record count does not match
    ${return}=    run process   python3 anz-code-challenge.py --schema scenarios/aus-capitals.json --data scenarios/aus-capitals.csv --tag scenarios/aus-capitals-invalid-1.tag --outputTableName sample.aus-capitals
    ${returnValue}=    Convert To Integer    ${return.rc}
    IF    ${returnValue} == 1
        Pass Execution
    END

TC-03 File name does not match
    ${return}=    run process   python3 anz-code-challenge.py --schema scenarios/aus-capitals.json --data scenarios/aus-capitals.csv --tag scenarios/aus-capitals-invalid-2.tag --outputTableName sample.aus-capitals
    ${returnValue}=    Convert To Integer    ${return.rc}
    IF    ${returnValue} == 1
        Pass Execution
    END