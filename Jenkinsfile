pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
    }

    stages {
        stage('Terraform Init & Apply') {
            steps {
                sh '''
                    terraform init
                    terraform apply -auto-approve
                '''
            }
        }

        stage('Verify EKS Cluster') {
            steps {
                sh '''
                    echo "✅ Terraform apply completed successfully."
                    echo "You can now run:"
                    echo "aws eks update-kubeconfig --region $AWS_REGION --name eks-cluster"
                '''
            }
        }

        stage('Approval Before Destroy') {
            steps {
                input message: 'Do you want to destroy the EKS cluster? (This will delete all resources)'
            }
        }

        stage('Terraform Destroy') {
            steps {
                sh '''
                    terraform destroy -auto-approve
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Jenkins pipeline completed successfully!"
        }
        failure {
            echo "❌ Pipeline failed. Check Terraform logs."
        }
    }
}
