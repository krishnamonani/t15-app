pipeline {
    agent { label 'prod-agent' }

    environment {
        GITHUB_CREDENTIALS = credentials('github-pat')
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo "Checking out code from GitHub repository..."
                git url: "https://github.com/krishnamonani/t15-app.git", branch: "main", credentialsId: 'github-pat'
                echo "Code checkout completed."
            }
        }
        stage("Build") {
            steps {
                echo "Starting the application..."
                sh "whoami"
                echo "down previous containers"
                sh "docker compose down"
                echo "up new containers"
                sh "docker compose up -d"
                echo "Application started."
            }
        }
        stage("Cleanup") {
            steps {
                echo "Cleaning up unused Docker resources..."
                sh "docker system prune -af"
                echo "Cleanup completed."
            }
        }
        stage("Smoke test") {
            steps {
                echo "Running smoke tests..."
                sh "curl -f http://localhost:5000 || exit 1"
                echo "Smoke tests passed."
            }
        }
    }
}
