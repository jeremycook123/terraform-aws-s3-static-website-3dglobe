pipeline {
    agent any

    environment {
        AUTHOR = "Jeremy Cook"
        REPO = "terraform-aws-s3-static-website-3dglobe"
        PIPELINE_VERSION = "0.0.8"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Detect Tag Build') {
            steps {
                script {
                def tag = sh(
                    script: "git tag --points-at HEAD",
                    returnStdout: true
                ).trim()

                env.IS_TAG_BUILD = tag ? 'true' : 'false'
                if (tag) {
                    echo "Tag build detected (${tag}). Remaining stages will be skipped."
                } else {
                    echo "Branch/PR build detected. Proceeding with full pipeline."
                }
                }
            }
        }        

        stage('Terraform Format') {
            when { expression { env.IS_TAG_BUILD != 'true' } }
            steps {
                sh 'terraform fmt -check -recursive'
            }
        }

        stage('Terraform Init') {
            when { expression { env.IS_TAG_BUILD != 'true' } }
            steps {
                sh 'terraform init -backend=false'
            }
        }

        stage('Terraform Validate') {
            when { expression { env.IS_TAG_BUILD != 'true' } }
            steps {
                sh 'terraform validate'
            }
        }

        stage('Terraform Lint') {
            when { expression { env.IS_TAG_BUILD != 'true' } }
            steps {
                sh '''
                if command -v tflint >/dev/null; then
                    tflint --init
                    tflint
                fi
                '''
            }
        }

        stage('Security Scan') {
            when { expression { env.IS_TAG_BUILD != 'true' } }
            steps {
                script {
                    int exitCode = sh(
                        label: 'Run tfsec',
                        script: '''
                        set -o pipefail
                        tfsec --no-color --format sarif --out tfsec.sarif . | tee tfsec.txt
                        ''',
                        returnStatus: true
                    )

                    if (exitCode != 0) {
                        echo "tfsec reported issues (exit code ${exitCode}). Marking build as UNSTABLE."
                        currentBuild.result = 'UNSTABLE'
                    } else {
                        echo 'tfsec passed with no issues.'
                    }
                }

                archiveArtifacts artifacts: 'tfsec.sarif, tfsec.txt', fingerprint: true, allowEmptyArchive: true

                recordIssues enabledForFailure: true, tools: [sarif(pattern: 'tfsec.sarif', name: 'tfsec')]
            }
        }

        stage('Generate Documentation') {
            when { expression { env.IS_TAG_BUILD != 'true' } }
            steps {
                sh '''
                terraform-docs markdown table \
                --output-file README.md \
                --output-mode inject .
                '''
            }
        }

        stage('Validate Examples') {
            when { expression { env.IS_TAG_BUILD != 'true' } }
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
            when { expression { env.IS_TAG_BUILD != 'true' } }
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
            when { expression { env.IS_TAG_BUILD != 'true' } }
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
            when { expression { env.IS_TAG_BUILD != 'true' } }
            steps {
                sh '''
                echo "## ${NEW_VERSION}" >> CHANGELOG.md
                git log --pretty=format:"- %s" $(git describe --tags --abbrev=0)..HEAD >> CHANGELOG.md
                '''
            }
        }

        stage('Commit Docs & Changelog') {
            when { expression { env.IS_TAG_BUILD != 'true' } }
            steps {

                withCredentials([usernamePassword(
                    credentialsId: 'github-creds',
                    usernameVariable: 'GIT_USER',
                    passwordVariable: 'GIT_TOKEN'
                )]) {

                    sh '''
                    git config user.name "jenkins"
                    git config user.email "jenkins@ci.local"

                    if [ -n "$(git status --porcelain)" ]; then
                        git add README.md CHANGELOG.md
                        git commit -m "auto: update docs and changelog [skip ci]"
                        git remote set-url origin https://${GIT_USER}:${GIT_TOKEN}@${GIT_URL#https://}
                        git push origin HEAD:main
                    else
                        echo "No changes to commit"
                    fi
                    '''
                }
            }
        }

        stage('Create Release Tag') {
            when { expression { env.IS_TAG_BUILD != 'true' } }
            steps {

                withCredentials([usernamePassword(
                    credentialsId: 'github-creds',
                    usernameVariable: 'GIT_USER',
                    passwordVariable: 'GIT_TOKEN'
                )]) {

                    sh '''
                    git tag ${NEW_VERSION}
                    git push https://${GIT_USER}:${GIT_TOKEN}@${GIT_URL#https://} ${NEW_VERSION}
                    '''
                }
            }
        }

        stage('Publish Notice') {
            when { expression { env.IS_TAG_BUILD != 'true' } }
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