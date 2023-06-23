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
                script {
                    def scanResult = sh(script: "bash docker-scan.sh", returnStdout: true).trim()

                    def highCount = sh(script: "echo '${scanResult}' | grep -o -E 'HIGH: [0-9]+' | awk '{print \$2}'", returnStdout: true).trim()
                    def criticalCount = sh(script: "echo '${scanResult}' | grep -o -E 'CRITICAL: [0-9]+' | awk '{print \$2}'", returnStdout: true).trim()

                    echo "Number of HIGH vulnerabilities: ${highCount}"
                    echo "Number of CRITICAL vulnerabilities: ${criticalCount}"
                }
            }
        }
    }
}
