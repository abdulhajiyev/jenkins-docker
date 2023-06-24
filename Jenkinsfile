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
                sh 'docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v $(pwd):/workdir aquasec/trivy:latest image --format json -o results.json jenkins-docker'
            }
        }
        
        stage('Generate HTML Report') {
            steps {
                // Convert the JSON scan results to HTML using a custom script
                sh 'python3 -c "import json, sys, html; vulns = json.load(open(\'results.json\')); html_report = \'<html><body><table><tr><th>Vulnerability</th><th>Severity</th></tr>\'; [html_report += \'<tr><td>{}</td><td>{}</td></tr>\'.format(html.escape(vuln[\'Vulnerability\']), vuln[\'Severity\']) for vuln in vulns]; html_report += \'</table></body></html>\'; sys.stdout.write(html_report)" > results.html'
            }
        }
        
        stage('Display Results in Jenkins') {
            steps {
                // Archive the HTML report as an artifact
                archiveArtifacts artifacts: 'results.html', onlyIfSuccessful: false
                
                // Publish the HTML report to be displayed in Jenkins
                publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: true, reportDir: '', reportFiles: 'results.html', reportName: 'Vulnerability Scan Report'])
            }
        }
    }
}
