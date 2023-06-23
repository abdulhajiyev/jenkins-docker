pipeline {
    agent any

    stages {
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t jenkins-docker .'
            }
        }

        stage('Install Trivy') {
            steps {
                sh 'wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -'
                sh 'echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list'
                sh 'sudo apt-get update'
                sh 'sudo apt-get install trivy'
            }
        }

        stage('Scan Docker Image with Trivy') {
            steps {
                script {
                    /* docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
                    -v $HOME/Library/Caches:/root/.cache/ aquasec/trivy:0.18.3 python:3.4-alpine */

                    def scanOutput = sh(script: 'docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v $HOME/Library/Caches:/root/.cache/ aquasec/trivy:0.18.3 jenkins-docker --format json', returnStdout: true).trim()

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
