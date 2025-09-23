pipeline {
    agent any
    
    environment {
        APP_NAME     = "sample-app"
        DOCKERHUB    = "krishnamonani"
        STAGING_HOST = "98.81.92.234"
        PROD_HOST    = "34.204.37.149"
        SSH_USER     = "ubuntu"
        SSH_KEY      = credentials('ubuntu-key')
        BRANCH_TAG   = "${env.BRANCH_NAME}-${env.BUILD_NUMBER}"
        IMAGE_NAME   = "${DOCKERHUB}/${APP_NAME}:${BRANCH_TAG}"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: "${env.BRANCH_NAME}", url: 'https://github.com/krishnamonani/t15-app.git'
            }
        }

        stage('Run Unit Tests (Dev only)') {
            when { branch 'dev' }
            steps {
                echo "Running tests inside Docker container..."
                sh 'docker compose -f docker-compose.test.yml up --build --abort-on-container-exit'
            }
        }

        stage('Build Docker Image') {
            when { branch pattern: "stage|prod", comparator: "REGEXP" }
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Push Docker Image') {
            when { branch pattern: "stage|prod", comparator: "REGEXP" }
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-cred', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh 'docker push $IMAGE_NAME'
                }
            }
        }

        stage('Deploy to Staging') {
            when { branch 'stage' }
            steps {
                sshagent(credentials: ['ubuntu-key']) {
                    sh """
                    ssh -o StrictHostKeyChecking=no $SSH_USER@$STAGING_HOST '
                        docker pull $IMAGE_NAME &&
                        docker stop $APP_NAME || true &&
                        docker rm $APP_NAME || true &&
                        docker run -d --name $APP_NAME -p 5000:5000 $IMAGE_NAME
                    '
                    """
                }
            }
        }

        stage('Deploy to Prod') {
            when { branch 'prod' }
            steps {
                sshagent(['ubuntu-key']) {
                    sh '''
                    ssh -o StrictHostKeyChecking=no $SSH_USER@$PROD_HOST "
                        docker pull $IMAGE_NAME &&
                        docker stop $APP_NAME || true &&
                        docker rm $APP_NAME || true &&
                        docker run -d --name $APP_NAME -p 80:80 $IMAGE_NAME
                    "
                    '''
                }
            }
        }

        stage('Post-Deploy Smoke Tests') {
            when { branch pattern: "stage|prod", comparator: "REGEXP" }
            steps {
                script {
                    def targetHost = (env.BRANCH_NAME == "stage") ? env.STAGING_HOST : env.PROD_HOST
                    sh """
                    echo "Running smoke tests on http://$targetHost"
                    curl -f http://$targetHost || (echo "Smoke tests FAILED!" && exit 1)
                    """
                }
            }
        }
    }
}