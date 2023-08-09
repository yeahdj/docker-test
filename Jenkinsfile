pipeline {
    agent any
    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
    }
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
        AWS_REGION = 'eu-west-1'
        ECS_CLUSTER = 'your_ecs_cluster_name'
    }
    stages {
        stage('Build') {
            steps {
                sh 'docker build -t djaoas/jenkins-docker-hub .'
            }
        }
        stage('Login') {
            steps {
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
            }
        }
        stage('Push') {
            steps {
                sh 'docker push djaoas/jenkins-docker-hub'
            }
        }
        stage('Redeploy ECS Cluster') {
            steps {
                script {
                    // Authenticate AWS CLI using Jenkins credentials
                    withCredentials([string(credentialsId: 'your_aws_credentials_id', variable: 'AWS_CREDENTIALS')]) {
                        sh "aws configure set aws_access_key_id $AWS_CREDENTIALS_AWS_ACCESS_KEY_ID"
                        sh "aws configure set aws_secret_access_key $AWS_CREDENTIALS_AWS_SECRET_ACCESS_KEY"
                        sh "aws configure set default.region $AWS_REGION"

                        // Redeploy ECS service
                        sh "aws ecs update-service --cluster $ECS_CLUSTER --service your_service_name --force-new-deployment"
                    }
                }
            }
        }
    }
    post {
        always {
            sh 'docker logout'
        }
    }
}
