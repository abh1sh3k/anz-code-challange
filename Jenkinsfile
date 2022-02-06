pipeline {
    agent { label 'Slave' }

    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
	    office365ConnectorWebhooks([[
                name: 'Jenkins',
                notifyBackToNormal: true,
                notifyFailure: true,
                notifySuccess: true,
                notifyUnstable: true,
                url: "https://xyz.webhook.office.com/webhookb2/0kal71"
            ]]
        )
    }

    parameters {
        gitParameter branchFilter: 'origin/(.*)', defaultValue: 'master', name: 'BRANCH', type: 'PT_BRANCH_TAG'
    }

    stages {
        stage('Cleanup') {
            steps {
                cleanWs()
            }
        }
        stage('Checkout') {
            steps {
                script {
                    currentBuild.displayName = "#${BUILD_NUMBER}->${params.BRANCH}"
                    currentBuild.description = "Branch: ${params.BRANCH} is used for this build"
                }
                git branch: "${params.BRANCH}", url: 'https://github.com/abh1sh3k/anz-code-challenge.git'
            }
        }
        stage('Static Code Analysis') {
            steps {
                withSonarQubeEnv('sonarqube_server') {
                    sh '''
                        docker run --rm --net=host -v (PWD)/src/main:/usr/src/main sonarsource/sonar-scanner-cli sonar-scanner -D sonar.projectBaseDir=/usr/src/main
                    '''
                }
            }
        }
        stage('Quality Gates') {
            steps {
                timeout(time: 1, unit: 'HOURS') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
        stage('Quality Check') {
            steps {
                sh '''
                    docker run --rm -v (PWD)/src/test:/usr/testcases -w /usr/testcases abh1sh3k/robotframework 
                '''
            }
            post{
                always {
                    robot archiveDirName: 'robot-plugin', outputPath: 'quality-check/testcases', overwriteXAxisLabel: ''
                    emailext attachmentsPattern: '*.html,*.xml', body: 'Attached test results.', subject: 'Quality check reports', to: 'abc@xyz.com'
                }
            }
        }
        stage('Build') {
            steps {
                sh '''
                    mkdir -p ${WORKSPACE}/anz-code-challenge
                    cp -r ${WORKSPACE}/src/test/* ${WORKSPACE}/anz-code-challenge
                    tar -czf anz-code-challenge.tar.gz anz-code-challenge
                '''
            }
        }
        stage('Deploy Build') {
            steps {
                sh "cp ${WORKSPACE}/anz-code-challenge.tar.gz /opt"
            }
        }
    }
}
