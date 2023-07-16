pipeline {
    agent { label 'default' }
    stages {
        stage('Tests') {
            steps {
                dir('src') {
                    sh 'pwd'
                    sh 'ls -a'
                }
            }
        }
        stage('Smoke Test') {
            steps {
                echo 'devops'
            }
        }
    }
}
