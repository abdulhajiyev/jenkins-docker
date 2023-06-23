#!/bin/bash

DOCKER_IMAGE_NAME="jenkins-docker"

# Run the Trivy vulnerability scanner
scanResult=$(docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image ${DOCKER_IMAGE_NAME}:jenkins.latest --scanners vuln --severity HIGH,CRITICAL --ignore-unfixed)

# echo "Vulnerability Scan Result:"
# echo "${scanResult}"

highCount=$(echo "${scanResult}" | grep -o -E 'HIGH: [0-9]+' | awk '{print $2}')
criticalCount=$(echo "${scanResult}" | grep -o -E 'CRITICAL: [0-9]+' | awk '{print $2}')

echo "Number of HIGH vulnerabilities: ${highCount}"
echo "Number of CRITICAL vulnerabilities: ${criticalCount}"
