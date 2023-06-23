pipeline {
    agent any
    
    stages {
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t jenkins-docker .'
            }
        }
        
        stage('Docker Image Scan') {
            steps {
                sh 'docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v $PWD:/root/ aquasec/trivy jenkins-docker'
            }
        }
    }
}
