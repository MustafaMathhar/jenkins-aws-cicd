pipeline {
    agent { label 'default' }
    stages {
        stage('Tests') {
            steps {
                dir('src') {
                    sh 'pwd'
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
