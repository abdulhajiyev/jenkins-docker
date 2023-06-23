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
                    echo "Scan result: ${scanResult}"

                    /* echo "Number of HIGH vulnerabilities: ${highCount}"
                    echo "Number of CRITICAL vulnerabilities: ${criticalCount}" */
                }
            }
        }
    }
}
