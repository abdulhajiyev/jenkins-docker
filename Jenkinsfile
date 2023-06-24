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
                    def vulnerabilityCount = sh (
                        script: 'trivy image mycontainerimage:latest --format "template|{{len .Vulnerabilities.HighSeverity}} high, {{len .Vulnerabilities.CriticalSeverity}} critical"',
                        returnStdout: true
                    ).trim()
                    
                    def highCount = vulnerabilityCount.split(" ")[0]
                    def criticalCount = vulnerabilityCount.split(" ")[2]
                    
                    echo "High Severity Count: $highCount"
                    echo "Critical Severity Count: $criticalCount"
                }
            }
        }
    }
}
