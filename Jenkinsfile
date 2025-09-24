pipeline {
    agent { label 'prod-agent' }

    environment {
        APP_NAME   = 'sample-app'
        DOCKERHUB  = 'krishnamonani'
        PROD_HOST  = '98.81.80.137'
        SSH_USER   = 'ubuntu'
        SSH_KEY    = credentials('ubuntu-key')
        BRANCH_TAG = "${env.BRANCH_NAME}-${env.BUILD_NUMBER}"
        IMAGE_NAME = "${DOCKERHUB}/${APP_NAME}:${BRANCH_TAG}"
    }

    stages {
        stage('Checkout Code') {
            steps {
                withCredentials([string(credentialsId: 'github-pat', variable: 'GITHUB_PAT')]) {
                    git branch: "prod",
                        url: "https://${GITHUB_PAT}@github.com/krishnamonani/t15-app.git"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-cred', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh 'docker push $IMAGE_NAME'
                }
            }
        }

        stage('Deploy to Production') {
            steps {
                sh """
                ssh -i $SSH_KEY -o StrictHostKeyChecking=no ubuntu@$PROD_HOST '
                    docker pull $IMAGE_NAME &&
                    docker stop $APP_NAME || true &&
                    docker rm $APP_NAME || true &&
                    docker run -d --name $APP_NAME -p 5000:5000 $IMAGE_NAME
                '
                """
            }
        }

        stage('Smoke Tests') {
            steps {
                sh """
                echo "Running smoke tests on http://$PROD_HOST"
                curl -f http://$PROD_HOST:5000 || (echo "Smoke tests FAILED!" && exit 1)
                """
            }
        }
    }
}
