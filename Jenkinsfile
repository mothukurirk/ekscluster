pipeline {
    agent any

    stages {
        stage('Terraform Init & Apply') {
            steps {
                sh '''
                    cd ekscluster
                    terraform init
                    terraform apply -auto-approve
                '''
            }
        }
    }

    post {
        success {
            echo "✅ EKS cluster successfully created!"
        }
        failure {
            echo "❌ Terraform apply failed. Check Jenkins logs."
        }
    }
}
