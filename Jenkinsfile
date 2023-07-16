pipeline {
    agent { label 'default' }
    tools {
            go 'go1.20.6'
    }
    environment {
        GO114MODULE = 'on'
        CGO_ENABLED = 0
        GOPATH = "${JENKINS_HOME}/jobs/${JOB_NAME}/builds/${BUILD_ID}"
    }
    stages {
        stage('Pre-test') {
                steps {
                echo 'Installing dependencies'
                sh 'go version'
                sh 'go get -u golang.org/x/lint/golint'
                }
        }
        stage('Tests') {
            steps {
                    withEnv(["PATH+GO=${GOPATH}/bin"]){
                    sh 'cd src'
                    echo 'Running vetting'
                    sh 'go vet .'
                    echo 'Running linting'
                    sh 'golint .'
                    echo 'Running test'
                    sh 'cd test && go test -v'
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
