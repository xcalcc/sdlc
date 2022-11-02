pipeline {
    agent {
        node '4.154-JenSlave'
    }
    
    environment {
        MASTIFF_BRANCH_REF = "develop"
        BRANCH_REF = "${BRANCH_REF ? BRANCH_REF : 'dev'}"
    }
    
    stages {
        stage('Create release branch for API gateway') {
            steps {
                sh """
                    curl -k --request POST --header "PRIVATE-TOKEN: $EXTERNAL_GITLAB_API_TOKEN" "$EXTERNAL_GITLAB_URL/api/v4/projects/xc5-sz%2Fxcal-apigateway/repository/branches?branch=$BRANCH_NAME&ref=$BRANCH_REF"
                """
            }
        }
        stage('Create release branch for sdlc from devnew - database/file service') {
            steps {
                sh """
                    curl -k --request POST --header "PRIVATE-TOKEN: $EXTERNAL_GITLAB_API_TOKEN" "$EXTERNAL_GITLAB_URL/api/v4/projects/xc5-sz%2Fsdlc/repository/branches?branch=$BRANCH_NAME&ref=devnew"
                """
            }
        }
        stage('Create release branch for xcal-product-setup') {
            steps {
                sh """
                    curl -k --request POST --header "PRIVATE-TOKEN: $EXTERNAL_GITLAB_API_TOKEN" "$EXTERNAL_GITLAB_URL/api/v4/projects/xc5-sz%2Fxcal-product-setup/repository/branches?branch=$BRANCH_NAME&ref=devnew"
                """
            }
        }
        stage('Create release branch for notification service') {
            steps {
                sh """
                    curl -k --request POST --header "PRIVATE-TOKEN: $EXTERNAL_GITLAB_API_TOKEN" "$EXTERNAL_GITLAB_URL/api/v4/projects/xc5-sz%2Fnotification-service/repository/branches?branch=$BRANCH_NAME&ref=$BRANCH_REF"
                """
            }
        }
        stage('Create release branch for protect-relay-server') {
            steps {
                sh """
                    curl -k --request POST --header "PRIVATE-TOKEN: $EXTERNAL_GITLAB_API_TOKEN" "$EXTERNAL_GITLAB_URL/api/v4/projects/xc5-sz%2Fprotect-relay-server/repository/branches?branch=$BRANCH_NAME&ref=$BRANCH_REF"
                """
            }
        }
        stage('Create release branch for protect-verify-server') {
            steps {
                sh """
                    curl -k --request POST --header "PRIVATE-TOKEN: $EXTERNAL_GITLAB_API_TOKEN" "$EXTERNAL_GITLAB_URL/api/v4/projects/xc5-sz%2Fprotect-verify-server/repository/branches?branch=$BRANCH_NAME&ref=$BRANCH_REF"
                """
            }
        }
        stage('Create release branch for rule-service') {
            steps {
                sh """
                    curl -k --request POST --header "PRIVATE-TOKEN: $EXTERNAL_GITLAB_API_TOKEN" "$EXTERNAL_GITLAB_URL/api/v4/projects/xc5-sz%2Frule-service/repository/branches?branch=$BRANCH_NAME&ref=$BRANCH_REF"
                """
            }
        }
        stage('Create release branch for scan service') {
            steps {
                sh """
                    curl -k --request POST --header "PRIVATE-TOKEN: $EXTERNAL_GITLAB_API_TOKEN" "$EXTERNAL_GITLAB_URL/api/v4/projects/xc5-sz%2Fxcalscan/repository/branches?branch=$BRANCH_NAME&ref=$BRANCH_REF"
                """
            }
        }
        stage('Create release branch for API service web main') {
            steps {
                sh """
                    curl -k --request POST --header "PRIVATE-TOKEN: $EXTERNAL_GITLAB_API_TOKEN" "$EXTERNAL_GITLAB_URL/api/v4/projects/xc5-sz%2Fweb-api-service-main/repository/branches?branch=$BRANCH_NAME&ref=$BRANCH_REF"
                """
            }
        }
        stage('Create release branch for web-frontend') {
            steps {
                sh """
                    curl -k --request POST --header "PRIVATE-TOKEN: $EXTERNAL_GITLAB_API_TOKEN" "$EXTERNAL_GITLAB_URL/api/v4/projects/xc5-sz%2Fweb-frontend/repository/branches?branch=$BRANCH_NAME&ref=$BRANCH_REF"
                """
            }
        }
        stage('Create release branch for xvsa verify server: mastiff/protect-verify-server/mastiff-package-protect') {
            steps {
                sh """
                    curl -k --request POST --header "PRIVATE-TOKEN: $EXTERNAL_GITLAB_API_TOKEN" "$EXTERNAL_GITLAB_URL/api/v4/projects/xc5-sz%2Fmastiff/repository/branches?branch=$BRANCH_NAME&ref=$MASTIFF_BRANCH_REF"
                """
                sh """
                    curl -k --request POST --header "PRIVATE-TOKEN: $EXTERNAL_GITLAB_API_TOKEN" "$EXTERNAL_GITLAB_URL/api/v4/projects/xc5-sz%2Fprotect-verify-server/repository/branches?branch=$BRANCH_NAME&ref=$BRANCH_REF"
                """
                sh """
                    curl -k --request POST --header "PRIVATE-TOKEN: $EXTERNAL_GITLAB_API_TOKEN" "$EXTERNAL_GITLAB_URL/api/v4/projects/xc5-sz%2Fmastiff-package-protect/repository/branches?branch=$BRANCH_NAME&ref=$BRANCH_REF"
                """
            }
        }
        stage('Create release branch for xcalbuild') {
            steps {
                sh """
                    curl -k --request POST --header "PRIVATE-TOKEN: $EXTERNAL_GITLAB_API_TOKEN" "$EXTERNAL_GITLAB_URL/api/v4/projects/xc5-sz%2Fxcalbuild-v2/repository/branches?branch=$BRANCH_NAME&ref=$BRANCH_REF"
                """
            }
        }
        stage('Create release branch for xcalclient') {
            steps {
                sh """
                    curl -k --request POST --header "PRIVATE-TOKEN: $EXTERNAL_GITLAB_API_TOKEN" "$EXTERNAL_GITLAB_URL/api/v4/projects/xc5-sz%2Fxcalclient/repository/branches?branch=$BRANCH_NAME&ref=$BRANCH_REF"
                """
            }
        }
    }
}
