pipeline {
    agent {
        label 'docker'
    }

    options {
        buildDiscarder(
            logRotator(numToKeepStr: '15', daysToKeepStr: '7', artifactDaysToKeepStr: '', artifactNumToKeepStr: '')
        )
        timeout(time:150, unit: 'MINUTES')
        skipDefaultCheckout()
    }

    environment {
        GIT_REPO_URL = 'https://github.com/bkbranden/GitversionJenkinsExperiment.git'
    }

    stages {
        stage('Pulling from Repo') {
            steps {
                sh "git config --global credential.helper 'cache --timeout=3600'"
                checkout scm
                sh "ls ."
                echo "branch name: ${env.BRANCH_NAME}"
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'apk update'
                sh 'apk add jq'
            }
        }

        stage ('Versioning') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'githubcreds',
                                                  usenameVariable: 'USER',
                                                  passwordVariable: 'PW')]) {
                    sh 'chmod o+x build/release-automation/version.sh'
                    sh "GITHUB_USER=${USER} \
                        GITHUB_PW=${PW} \
                        BRANCH=${env.BRANCH_NAME} \
                        URL=${GIT_REPO_URL} \
                        version.sh"
                }
            }
        }
    }
}