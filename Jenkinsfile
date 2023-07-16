def dockerImage
pipeline {
    agent { label 'default' }
    tools {
            go 'go-1.20'
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
                }
        }
        stage('Tests') {
            steps {
                    withEnv(["PATH+GO=${GOPATH}/bin"]) {
                        dir('src') {
                            echo 'Running vetting'
                                sh 'go vet .'
                                echo 'Running test'
                                sh 'go test -v'
                        }
                    }
            }
        }
        stage('Smoke Test') {
            steps {
                dir('src') {
                    echo 'Running smoke test'
                    sh 'go build .'
                    script {
                        dockerImage = docker.build('fangg23/hello_docker_jenkins:latest')
                    }
                }
            }
        }
        stage('Build dockerfile') {
                steps {
                sh 'docker build -t fangg23/hello_docker_jenkins:latest .'
                withDockerRegistry([ credentialsId: 'DOCKERHUB_JENKINS', url: '' ]) {
                    script {
                        dockerImage.push()
                    }
                }
                }
        }
    }
}
