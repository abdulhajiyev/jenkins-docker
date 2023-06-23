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
                    def trivyOutput = sh(script: 'docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v /var/jenkins_home/workspace/jenkins-docker_master:/root/ aquasec/trivy --format json jenkins-docker:tag', returnStdout: true).trim()
                    def vulnerabilities = readJSON(text: trivyOutput)
                    
                    def highVulnerabilities = vulnerabilities.findAll { it.Severity == 'HIGH' }
                    def criticalVulnerabilities = vulnerabilities.findAll { it.Severity == 'CRITICAL' }
                    
                    echo "Number of High Vulnerabilities: ${highVulnerabilities.size()}"
                    echo "Number of Critical Vulnerabilities: ${criticalVulnerabilities.size()}"
                }
            }
        }
    }
}
