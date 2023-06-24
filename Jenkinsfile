pipeline {
    agent any

    stages {
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t jenkins-docker .'
            }
        }
        
        stage('Scan Docker Image') {
            steps {
                // Run Trivy in a Docker container to scan the Docker image for vulnerabilities
                sh 'docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v $(pwd):/workdir aquasec/trivy:latest image --format json --output results.json jenkins-docker'
            }
        }
        
        stage('Generate HTML Report') {
            steps {
                // Convert the JSON scan results to HTML using Trivy itself
                sh 'docker run --rm -v $(pwd):/workdir aquasec/trivy:latest report --format html --output results.html --input results.json'
            }
        }
        
        stage('Display Results in Jenkins') {
            steps {
                // Archive the HTML report as an artifact
                archiveArtifacts artifacts: 'results.html', onlyIfSuccessful: false
                
                // Publish the HTML report to be displayed in Jenkins
                publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: true, reportDir: '', reportFiles: 'results.html', reportName: 'Vulnerability Scan Report'])
            }
        }
    }
}
