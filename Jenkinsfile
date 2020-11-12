pipeline {
    agent any

    options {
        buildDiscarder(
            logRotator(numToKeepStr: '15', daysToKeepStr: '7', artifactDaysToKeepStr: '', artifactNumToKeepStr: '')
        )
        timeout(time:150, unit: 'MINUTES')
        skipDefaultCheckout()
    }

    stages {
        stage('Pulling from Repo') {
            steps {
                sh "git config --global credential.helper 'cache --timeout=3600'"
                checkout scm
            }
        }
    }
}