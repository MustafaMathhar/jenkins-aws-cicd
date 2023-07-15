pipeline {
    agent { label 'jenkins-jnlp' }
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
