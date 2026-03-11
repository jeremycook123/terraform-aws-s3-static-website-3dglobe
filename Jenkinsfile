pipeline {
    agent any

    environment {
        AUTHOR = "Jeremy Cook"
        REPO = "terraform-aws-example"
        VERSION = "0.0.1"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Format') {
            steps {
                sh 'terraform fmt -check -recursive'
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init -backend=false'
            }
        }

        stage('Terraform Validate') {
            steps {
                sh 'terraform validate'
            }
        }

        stage('Lint Terraform') {
            steps {
                sh '''
                if command -v tflint >/dev/null; then
                    tflint --init
                    tflint
                fi
                '''
            }
        }

        // stage('Security Scan') {
        //     steps {
        //         sh '''
        //         if command -v tfsec >/dev/null; then
        //             tfsec .
        //         else
        //             echo "tfsec not installed"
        //         fi
        //         '''
        //     }
        // }

        stage('Generate Documentation') {
            steps {
                sh '''
                terraform-docs markdown table \
                --output-file README.md \
                --output-mode inject .
                '''
            }
        }

        stage('Validate Examples') {
            steps {
                sh '''
                for example in examples/*; do
                    echo "Validating $example"
                    cd $example
                    terraform init -backend=false
                    terraform validate
                    cd -
                done
                '''
            }
        }

        stage('Determine Version') {
            steps {
                script {

                    def commitMsg = sh(
                        script: "git log -1 --pretty=%B",
                        returnStdout: true
                    ).trim()

                    if (commitMsg.contains("BREAKING")) {
                        env.VERSION_BUMP = "major"
                    }
                    else if (commitMsg.contains("feat")) {
                        env.VERSION_BUMP = "minor"
                    }
                    else {
                        env.VERSION_BUMP = "patch"
                    }
                }
            }
        }

        stage('Generate Version') {
            steps {
                script {

                    def lastTag = sh(
                        script: "git describe --tags --abbrev=0 || echo v0.0.0",
                        returnStdout: true
                    ).trim()

                    def version = lastTag.replace("v","").tokenize('.')

                    def major = version[0].toInteger()
                    def minor = version[1].toInteger()
                    def patch = version[2].toInteger()

                    if (env.VERSION_BUMP == "major") {
                        major++
                        minor = 0
                        patch = 0
                    }
                    else if (env.VERSION_BUMP == "minor") {
                        minor++
                        patch = 0
                    }
                    else {
                        patch++
                    }

                    env.NEW_VERSION = "v${major}.${minor}.${patch}"
                }
            }
        }

        stage('Generate Changelog') {
            steps {
                sh '''
                echo "## ${NEW_VERSION}" >> CHANGELOG.md
                git log --pretty=format:"- %s" $(git describe --tags --abbrev=0)..HEAD >> CHANGELOG.md
                '''
            }
        }

        stage('Commit Docs & Changelog') {
            steps {

                withCredentials([usernamePassword(
                    credentialsId: 'github-creds',
                    usernameVariable: 'GIT_USER',
                    passwordVariable: 'GIT_TOKEN'
                )]) {

                    sh '''
                    git config user.name "jenkins"
                    git config user.email "jenkins@ci.local"

                    if [[ `git status --porcelain` ]]; then
                        git add README.md CHANGELOG.md
                        git commit -m "auto: update docs and changelog [skip ci]"
                        git push https://${GIT_USER}:${GIT_TOKEN}@github.com/${GIT_URL#https://} HEAD:main
                    fi
                    '''
                }
            }
        }

        stage('Create Release Tag') {
            steps {

                withCredentials([usernamePassword(
                    credentialsId: 'github-creds',
                    usernameVariable: 'GIT_USER',
                    passwordVariable: 'GIT_TOKEN'
                )]) {

                    sh '''
                    git tag ${NEW_VERSION}
                    git push https://${GIT_USER}:${GIT_TOKEN}@github.com/${GIT_URL#https://} ${NEW_VERSION}
                    '''
                }
            }
        }

        stage('Publish Notice') {
            steps {
                echo """
Module release triggered

Version: ${NEW_VERSION}

Terraform Registry will detect the tag and
publish the module automatically.
"""
            }
        }
    }

    post {
        success {
            echo "Release completed"
        }

        failure {
            echo "Pipeline failed"
        }
    }
}