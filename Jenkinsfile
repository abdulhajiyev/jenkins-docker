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
                            sudo docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v $(pwd):/workdir aquasec/trivy:latest image jenkins-docker
                        ''',
                        returnStdout: true
                    ).trim()

                    def highCriticalCount = trivyOutput =~ /(HIGH|CRITICAL)/
                    def highCriticalCountValue = highCriticalCount.size()

                    echo "Number of HIGH and CRITICAL vulnerabilities: ${highCriticalCountValue}"
                }
            }
        }
    }
}
