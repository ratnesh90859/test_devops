pipeline {
    agent any

    parameters {
        string(name: 'VM_IP', description: 'The Public IP address of the GCP VM created by Terraform')
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Node') {
            steps {
                sh 'node --version'
                sh 'npm --version'
            }
        }

        stage('Build React App') {
            steps {
                dir('frontend') {
                    sh 'npm install'
                    sh 'npm run build'
                }
            }
        }

        stage('Deploy to VM (Nginx)') {
            steps {
                // Using the SSH Private Key securely generated on your Mac
                // We use StrictHostKeyChecking=no to automatically accept the new VM's identity
                sh '''
                scp -o StrictHostKeyChecking=no -i /Users/ratneshsingh/.ssh/gcp_jenkins_rsa -r frontend/dist/* jenkins@${params.VM_IP}:/var/www/html/
                '''
            }
        }
    }
    
    post {
        success {
            echo "Website deployed successfully! Visit http://${params.VM_IP}/"
        }
    }
}
