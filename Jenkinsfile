pipeline {
    agent { label 'docker-jnlp' }
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
