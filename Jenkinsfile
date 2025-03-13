pipeline {
    // Define the agent where the pipeline will run (any available agent)
    agent any

    // Define tools if needed (e.g., specific .NET SDK version)
    tools {
        dotnet '8.0' // Ensure Jenkins has .NET 8.0 configured; adjust version as needed
    }

    // Environment variables (optional, e.g., for Docker Hub credentials)
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials-id') // Add this in Jenkins credentials
        IMAGE_NAME = "yourusername/simple-console-app" // Replace with your Docker Hub username
        IMAGE_TAG = "${env.BUILD_NUMBER}" // Uses Jenkins build number as tag
    }

    stages {
        // Stage 1: Checkout code from GitHub
        stage('Checkout') {
            steps {
                git url: 'https://github.com/Gowthamg1412/ZenkinsExample.git', branch: 'main'
            }
        }

        // Stage 2: Restore .NET dependencies
        stage('Restore') {
            steps {
                sh 'dotnet restore'
            }
        }

        // Stage 3: Build the .NET app
        stage('Build') {
            steps {
                sh 'dotnet build --configuration Release'
            }
        }

        // Stage 4: Run tests (optional, placeholder for future tests)
        stage('Test') {
            steps {
                echo 'No tests defined yet. Add dotnet test here if tests are added.'
                // Example: sh 'dotnet test --configuration Release'
            }
        }

        // Stage 5: Build Docker image
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
                }
            }
        }

        // Stage 6: Test the Docker image (optional)
        stage('Test Docker Image') {
            steps {
                script {
                    docker.image("${IMAGE_NAME}:${IMAGE_TAG}").run('-d') // Run in detached mode
                    echo 'Docker container started. Add further tests if needed.'
                }
            }
        }

        // Stage 7: Push Docker image to Docker Hub (optional)
        stage('Push to Docker Hub') {
            when {
                branch 'main' // Only push on main branch (optional condition)
            }
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials-id') {
                        docker.image("${IMAGE_NAME}:${IMAGE_TAG}").push()
                        docker.image("${IMAGE_NAME}:${IMAGE_TAG}").push('latest') // Tag as latest
                    }
                }
            }
        }
    }

    // Post-build actions (e.g., cleanup or notifications)
    post {
        always {
            echo 'Pipeline completed!'
            // Optional: Clean up Docker images locally
            // sh 'docker rmi ${IMAGE_NAME}:${IMAGE_TAG} || true'
        }
        success {
            echo 'Build and deployment succeeded!'
        }
        failure {
            echo 'Pipeline failed. Check logs for details.'
        }
    }
}