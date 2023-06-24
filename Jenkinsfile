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
                    def trivyOutput = sh(script: "docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image jenkins-docker --scanners vuln --severity HIGH,CRITICAL --ignore-unfixed | grep 'Total: '", returnStdout: true).trim()

                    echo "${trivyOutput}"


                    def highCount = trivyOutput =~ /HIGH: (\d+)/
                    def criticalCount = trivyOutput =~ /CRITICAL: (\d+)/

                    def highVulnerabilities = highCount[0][1].toInteger()
                    def criticalVulnerabilities = criticalCount[0][1].toInteger()

                    if (highVulnerabilities > 0 || criticalVulnerabilities > 0) {
                        currentBuild.result = 'UNSTABLE'
                    }
                    else {
                        currentBuild.result = 'SUCCESS'
                    }
                }
            }
        }
    }
}
