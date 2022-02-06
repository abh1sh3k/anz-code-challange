# anz-code-challange

## Challenge

This challange has two parts:

### 1. Application
    - Application to accept 4 mandatory paramters
    - It should validate the file name and record count from tag file
        - If record count doesn't match then application should exit with return code 1
        - If file name doesn't match then application should exit with return code 2
    - If validation is success:
        - Load data file to HDFS
        - Create table in HIVE using schema
        - Load csv from HDFS to HIVE table
### 2. CI-CD
    - Cleans up the workspace before execution
    - Checkout the project
    - Run code analysis and linting using sonarqube docker container
    - Run quality check tests using robotframework docker container
    - Bundle the package
    - Deploy on local machine

## Code Structure

### Jenkinsfile

Jenkinsfile has been written in declarative pipeline supported by Jenkins.

### ci-cd

This section has all the dockerfile and related files:

###### hdfs-hive-spark-docker

This folder is used to create an image of hadoop, hive and spark.

###### jenkins-sonarqube-docker

This folder is used to run jenkins and sonarqube docker container using docker-compose.

###### robotframework-docker

This folder is used to create an image of robotframework to run the quality checks.

###### test_results_validator.sh

This script takes path as an input to check FAIL in the xmls available in the path. This is nowhere used in the CI-CD pipeline but has been kept due to the requirement in the challenge.

### src

###### src/main

This folder contains the application written in Python, config file and the dependency file.

###### src/test

This folder contains the testcase written in robotframework to validated all 3 scenarios given in the challenge.


