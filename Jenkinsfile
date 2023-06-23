pipeline {
    agent any

    stages {
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t jenkins-docker .'
            }
        }

        stage('Scan Docker Image with Trivy') {
            steps {
                script {
                    def scanOutput = sh(script: 'trivy jenkins-docker --format json', returnStdout: true).trim()
                    def vulnerabilities = readJSON(text: scanOutput)

                    def highCount = vulnerabilities.Vulnerabilities.findAll { it.Severity == 'HIGH' }.size()
                    def criticalCount = vulnerabilities.Vulnerabilities.findAll { it.Severity == 'CRITICAL' }.size()

                    echo "High Vulnerabilities: ${highCount}"
                    echo "Critical Vulnerabilities: ${criticalCount}"
                }
            }
        }
    }
}
