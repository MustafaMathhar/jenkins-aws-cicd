pipeline {
    agent { label 'java-docker-slave' }
    stages {
        stage('Hello') {
            steps {
                echo 'Hello..'
                echo 'ECHO ECHO'
                sh 'docker build'
            }
        }
    }
}
