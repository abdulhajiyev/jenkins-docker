pipeline {
    agent any

    stage('Build Docker Image') {
        steps {
            sh 'docker build -t jenkins-docker .'
        }
    }

    /* stage('Install Trivy') {
        steps {
            sh 'wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -'
            sh 'echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list'
            sh 'sudo apt-get update'
            sh 'sudo apt-get install trivy'
        }
    } */

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
