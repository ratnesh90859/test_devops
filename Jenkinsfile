pipeline {
    agent any

    environment {
        // We set the credentials ID that you will configure in Jenkins for GCP
        GCP_CREDENTIALS_ID = 'gcp-credentials'
    }

    parameters {
        string(name: 'BUCKET_NAME', description: 'The GCS Bucket name created by Terraform (e.g., todo-react-app-xxxx)')
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout code from Git (or use local workspace if running locally)
                checkout scm
            }
        }

        stage('Install Node') {
            steps {
                // For demonstration, assuming node/npm is available on the Jenkins agent
                // In production, you might use NodeJS plugin:
                // tools { nodejs "node-20" }
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

        stage('Deploy to GCP GCS') {
            steps {
                // Use the Google Cloud SDK tool (gsutil).
                // withCredentials will inject the service account JSON file into the pipeline
                withCredentials([file(credentialsId: "${env.GCP_CREDENTIALS_ID}", variable: 'GC_KEY')]) {
                    sh '''
                    # Authenticate to GCP using the Service Account key
                    gcloud auth activate-service-account --key-file=${GC_KEY}
                    
                    # Sync the dist folder to the GCS Bucket
                    gsutil -m rsync -r frontend/dist/ gs://${params.BUCKET_NAME}/
                    
                    # Ensure the cache control is set for index.html so updates are immediate
                    gsutil setmeta -h "Cache-Control:private, max-age=0, no-transform" gs://${params.BUCKET_NAME}/index.html
                    '''
                }
            }
        }
    }
    
    post {
        success {
            echo "Website deployed successfully! Visit http://storage.googleapis.com/${params.BUCKET_NAME}/index.html"
        }
    }
}
