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
                    def trivyOutput = docker.image('aquasec/trivy:latest').run("-v $PWD:/workdir --rm --severity HIGH,CRITICAL --format json jenkins-docker:tag")

                    def trivyJson = readJSON(text: trivyOutput.text())

                    def highVulnCount = trivyJson[0].Vulnerabilities.high
                    def criticalVulnCount = trivyJson[0].Vulnerabilities.critical
                    
                    echo "High Vulnerabilities: ${highVulnCount}"
                    echo "Critical Vulnerabilities: ${criticalVulnCount}"
                }
            }
        }
    }
}
