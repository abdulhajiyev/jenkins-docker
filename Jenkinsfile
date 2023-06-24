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
        
        stage('Scan Docker Image') {
            steps {
                // Run Trivy in a Docker container to scan the Docker image for vulnerabilities
                script {
                    def trivyOutput = sh(returnStdout: true, script: 'docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v $(pwd):/workdir aquasec/trivy:latest image --format json jenkins-docker')
                    def vulnerabilities = readJSON(text: trivyOutput)
                    
                    // Filter vulnerabilities by severity (high and critical)
                    def highAndCritical = vulnerabilities.findAll { it.Severity in ['HIGH', 'CRITICAL'] }
                    
                    // Print the high and critical vulnerabilities in the Jenkins console
                    echo 'High and Critical Vulnerabilities:'
                    highAndCritical.each { vulnerability ->
                        echo "Package: ${vulnerability.PkgName}"
                        echo "Version: ${vulnerability.InstalledVersion}"
                        echo "Severity: ${vulnerability.Severity}"
                        echo "Description: ${vulnerability.Title}"
                        echo '---'
                    }
                }
            }
        }
    }
}
