pipeline {
    agent {
        label '4.154-JenSlave'
    }
    
    environment {
        MASTIFF_BRANCH_REF = "develop"
        BRANCH_REF = "${BRANCH_REF ? BRANCH_REF : 'dev'}"
    }

    stages {
        stage('Create release branch for notification service') {
            steps {
                sh'''
                    curl -i --digest --user $INTERNAL_GERRIT_BASIC_AUTH_USER:$INTERNAL_GERRIT_BASIC_AUTH_SECRET --request PUT "$INTERNAL_GERRIT_URL/a/projects/notification-service/branches/$BRANCH_NAME" \
                        --header "Content-Type: application/json"  \
                        -d "{ref: $BRANCH_REF}"
                '''
            }
        }
        stage('Create release branch for rule-service') {
            steps {
                sh'''
                    curl -i --digest --user $INTERNAL_GERRIT_BASIC_AUTH_USER:$INTERNAL_GERRIT_BASIC_AUTH_SECRET --request PUT "$INTERNAL_GERRIT_URL/a/projects/rule-service/branches/$BRANCH_NAME" \
                        --header "Content-Type: application/json"  \
                        -d "{ref: $BRANCH_REF}"
                '''
            }
        }
        stage('Create release branch for scan service') {
            steps {
                sh'''
                    curl -i --digest --user $INTERNAL_GERRIT_BASIC_AUTH_USER:$INTERNAL_GERRIT_BASIC_AUTH_SECRET --request PUT "$INTERNAL_GERRIT_URL/a/projects/xcalscan/branches/$BRANCH_NAME" \
                        --header "Content-Type: application/json"  \
                        -d "{ref: $BRANCH_REF}"
                '''
            }
        }
        stage('Create release branch for API service web main') {
            steps {
                sh'''
                    curl -i --digest --user $INTERNAL_GERRIT_BASIC_AUTH_USER:$INTERNAL_GERRIT_BASIC_AUTH_SECRET --request PUT "$INTERNAL_GERRIT_URL/a/projects/web-api-service-main/branches/$BRANCH_NAME" \
                        --header "Content-Type: application/json"  \
                        -d "{ref: $BRANCH_REF}"
                '''
            }
        }
        stage('Create release branch for web-frontend') {
            steps {
                sh'''
                    curl -i --digest --user $INTERNAL_GERRIT_BASIC_AUTH_USER:$INTERNAL_GERRIT_BASIC_AUTH_SECRET --request PUT "$INTERNAL_GERRIT_URL/a/projects/web-frontend/branches/$BRANCH_NAME" \
                        --header "Content-Type: application/json"  \
                        -d "{ref: $BRANCH_REF}"
                '''
            }
        }
        stage('Create release branch for xvsa verify server: mastiff/protect-verify-server/mastiff-package-protect') {
            steps {
                echo "Creating branch for xvsa"
                sh'''
                    curl -i --digest --user $INTERNAL_GERRIT_BASIC_AUTH_USER:$INTERNAL_GERRIT_BASIC_AUTH_SECRET --request PUT "$INTERNAL_GERRIT_URL/a/projects/mastiff/branches/$BRANCH_NAME" \
                        --header "Content-Type: application/json"  \
                        -d "{ref: $MASTIFF_BRANCH_REF}"
                '''
                echo "Creating branch for xsca"
                sh'''
                    curl -i --digest --user $INTERNAL_GERRIT_BASIC_AUTH_USER:$INTERNAL_GERRIT_BASIC_AUTH_SECRET --request PUT "$INTERNAL_GERRIT_URL/a/projects/labrador/branches/$BRANCH_NAME" \
                        --header "Content-Type: application/json"  \
                        -d "{ref: $BRANCH_REF}"
                '''
                echo "Creating branch for xvsa package protect"
                sh'''
                    curl -i --digest --user $INTERNAL_GERRIT_BASIC_AUTH_USER:$INTERNAL_GERRIT_BASIC_AUTH_SECRET --request PUT "$INTERNAL_GERRIT_URL/a/projects/mastiff-package-protect/branches/$BRANCH_NAME" \
                        --header "Content-Type: application/json"  \
                        -d "{ref: $BRANCH_REF}"
                '''
            }
        }
    }
}
