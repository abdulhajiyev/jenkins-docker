pipeline {
    agent any

    stages {
        stage('Build Docker Image') {
            steps {
                // Checkout source code or use copyArtifacts to get the Dockerfile
                // Build the Docker image
                sh 'docker build -t jenkins-docker .'
            }
        }

        stage('Trivy Scan') {
            steps {
                script {
                    def trivyOutput = sh(
                        script: '''
                        docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v $(pwd):/workdir aquasec/trivy:latest image jenkins-docker --scanners vuln --severity HIGH,CRITICAL --ignore-unfixed | grep 'Total: '
                        ''',
                        returnStdout: true).trim()
                }
            }
        }
    }
}
