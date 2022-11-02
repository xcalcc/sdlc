pipeline {
    agent {
        label "4.154-JenSlave"
    }

    environment {
        AGENT = "4.154-JenSlave"
        VERSION = "${VERSION}"
        BRANCH_NAME = "${BRANCH_NAME}"
        REF_BRANCH = "${REF_BRANCH}"
        XVSA_BRANCH_NAME = "develop"
        DOCKER_IMAGE_REGISTRY = "hub.xcalibyte.co"

        API_GATEWAY_IMAGE = 'hub.xcalibyte.co/xcalscan/xcal.apigateway'
        DATABASE_IMAGE = 'hub.xcalibyte.co/xcalscan/xcal.database'
        FILE_SERVICE_IMAGE = 'hub.xcalibyte.co/xcalscan/xcal.file-service'
        NOTIFICATION_SERVICE_IMAGE = 'hub.xcalibyte.co/xcalscan/xcal.notification-service'
        BUILD_PROTECT_RELAY_IMAGE = 'hub.xcalibyte.co/xcalscan/xcal.pro-relay'
        RULE_SERVICE_IMAGE = 'hub.xcalibyte.co/xcalscan/xcal.rule-service'
        SCAN_SERVICE_IMAGE = 'hub.xcalibyte.co/xcalscan/xcal.scan-service'
        MAIN_API_SERVICE_IMAGE = 'hub.xcalibyte.co/xcalscan/xcal.main-service'
        WEB_UI_SERVICE_IMAGE = 'hub.xcalibyte.co/xcalscan/xcal.webfrontend'
        XVSA_IMAGE = 'hub.xcalibyte.co/xcalscan/xcal.xvsa'
        VERIFY_IMAGE = 'hub.xcalibyte.co/xcalscan/xcal.pro-verify'

        NEXUS_REPO_USER = "${NEXUS_REPO_USER}"
        NEXUS_REPO_PSW = "${NEXUS_REPO_PSW}"
        NEXUS_REPO_ADDRESS_SH = "${NEXUS_REPO_ADDRESS_SH ?: ''}"
        NEXUS_REPO_ADDRESS_SZ = "${NEXUS_REPO_ADDRESS_SZ ?: ''}"


        NEXUS_REPO_ADDRESS_XVSA_SH = "${NEXUS_REPO_ADDRESS_XVSA_SH ?: ''}"
        NEXUS_REPO_ADDRESS_XVSA_SZ = "${NEXUS_REPO_ADDRESS_XVSA_SZ ?: ''}"
        XVSA_BUILD_SERVER = "${XVSA_BUILD_SERVER ?: 'http://127.0.0.1:7881'}"
        XSCA_BRANCH_NAME = "${XSCA_BRANCH_NAME ? XSCA_BRANCH_NAME : 'dev'}"
        XVSAPRO_BRANCH_NAME = "${XVSAPRO_BRANCH_NAME ?: 'dev'}"
        VERIFY_BRANCH_NAME = "${VERIFY_BRANCH_NAME ?: 'dev'}"

        NOTIFY_EMAILS = "${NOTIFY_EMAILS}"
        AUTO_TEST_SERVER = "${AUTO_TEST_SERVER}"
    }

    stages {
        stage("api gateway") {
            steps {
                build job: 'newbuild_apigateway_dev', parameters: [string(name: 'SDLC_REPO_BRANCH', value: 'devnew'), string(name: 'AGENT', value: "${AGENT}"), string(name: 'VERSION', value: "${VERSION}"), string(name: 'APIGATEWAY_BRANCH_NAME', value: "${BRANCH_NAME}"), string(name: 'REGISTRY', value: "${DOCKER_IMAGE_REGISTRY}"), string(name: 'IMAGE_NAME', value: "${API_GATEWAY_IMAGE}"), string(name: 'COMMIT_ID', value: '')]
            }
        }
        stage("database") {
            steps {
                build job: 'newbuild_database_dev', parameters: [string(name: 'SDLC_REPO_BRANCH', value: 'devnew'), string(name: 'AGENT', value: "${AGENT}"), string(name: 'VERSION', value: "${VERSION}"), string(name: 'DATABASE_BRANCH_NAME', value: "${BRANCH_NAME}"), string(name: 'REGISTRY', value: "${DOCKER_IMAGE_REGISTRY}"), string(name: 'IMAGE_NAME', value: "${DATABASE_IMAGE}"), string(name: 'COMMIT_ID', value: '')]
            }
        }
        stage("file service") {
            steps {
                build job: 'newbuild_fileservice_dev', parameters: [string(name: 'SDLC_REPO_BRANCH', value: 'devnew'), string(name: 'AGENT', value: "${AGENT}"), string(name: 'VERSION', value: "${VERSION}"), string(name: 'REGISTRY', value: "${DOCKER_IMAGE_REGISTRY}"), string(name: 'IMAGE_NAME', value: "${FILE_SERVICE_IMAGE}")]
            }
        }
        stage("notification service") {
            steps {
                build job: 'newbuild_notificationtmp_dev', parameters: [string(name: 'SDLC_REPO_BRANCH', value: 'devnew'), string(name: 'AGENT', value: "${AGENT}"), string(name: 'VERSION', value: "${VERSION}"), string(name: 'BRANCH_NAME', value: "${BRANCH_NAME}"), string(name: 'REGISTRY', value: "${DOCKER_IMAGE_REGISTRY}"), string(name: 'IMAGE_NAME', value: "${NOTIFICATION_SERVICE_IMAGE}"), string(name: 'COMMIT_ID', value: '')]
            }
        }
        stage("protect relay") {
            steps {
                build job: 'newbuild_protectrelay_dev', parameters: [string(name: 'SDLC_REPO_BRANCH', value: 'devnew'), string(name: 'AGENT', value: "${AGENT}"), string(name: 'VERSION', value: "${VERSION}"), string(name: 'RELAY_BRANCH_NAME', value: "${BRANCH_NAME}"), string(name: 'REGISTRY', value: "${DOCKER_IMAGE_REGISTRY}"), string(name: 'IMAGE_NAME', value: "${BUILD_PROTECT_RELAY_IMAGE}")]
            }
        }
        stage("rule service") {
            steps {
                build job: 'newbuild_ruleservice_dev', parameters: [string(name: 'SDLC_REPO_BRANCH', value: 'devnew'), string(name: 'AGENT', value: "${AGENT}"), string(name: 'VERSION', value: "${VERSION}"), string(name: 'BRANCH_NAME', value: "${BRANCH_NAME}"), string(name: 'REGISTRY', value: "${DOCKER_IMAGE_REGISTRY}"), string(name: 'IMAGE_NAME', value: "${RULE_SERVICE_IMAGE}"), string(name: 'COMMIT_ID', value: '')]
            }
        }
        stage("scan service") {
            steps {
                build job: 'newbuild_scanservice_dev', parameters: [string(name: 'SDLC_REPO_BRANCH', value: 'devnew'), string(name: 'AGENT', value: "${AGENT}"), string(name: 'VERSION', value: "${VERSION}"), string(name: 'SCANSERVICE_BRANCH_NAME', value: "${BRANCH_NAME}"), string(name: 'REGISTRY', value: "${DOCKER_IMAGE_REGISTRY}"), string(name: 'IMAGE_NAME', value: "${SCAN_SERVICE_IMAGE}"), string(name: 'COMMIT_ID', value: '')]
            }
        }
        stage("webmain api") {
            steps {
                build job: 'newbuild_webmain_dev', parameters: [string(name: 'SDLC_REPO_BRANCH', value: 'devnew'), string(name: 'AGENT', value: "${AGENT}"), string(name: 'VERSION', value: "${VERSION}"), string(name: 'MAINSERVICE_BRANCH_NAME', value: "${BRANCH_NAME}"), string(name: 'REGISTRY', value: "${DOCKER_IMAGE_REGISTRY}"), string(name: 'IMAGE_NAME', value: "${MAIN_API_SERVICE_IMAGE}"), string(name: 'M2_DIR', value: '/home/xc5/build_use_m2'), string(name: 'COMMIT_ID', value: '')]
            }
        }
        stage("web page") {
            steps {
                build job: 'newbuild_webpage_dev', parameters: [string(name: 'SDLC_REPO_BRANCH', value: 'devnew'), string(name: 'AGENT', value: "${AGENT}"), string(name: 'VERSION', value: "${VERSION}"), string(name: 'WEBFRONTEND_BRANCH_NAME', value: "${BRANCH_NAME}"), string(name: 'REGISTRY', value: "${DOCKER_IMAGE_REGISTRY}"), string(name: 'IMAGE_NAME', value: "${WEB_UI_SERVICE_IMAGE}"), string(name: 'COMMIT_ID', value: '')]
            }
        }
        stage("xvsa") {
            steps {
                build job: 'newbuild_xvsa_with_verify_dev', parameters: [string(name: 'SDLC_REPO_BRANCH', value: 'devnew'), string(name: 'AGENT', value: "${AGENT}"), string(name: 'VERSION', value: "${VERSION}"), string(name: 'XVSA_BRANCH_NAME', value: "${XVSA_BRANCH_NAME}"), string(name: 'VERIFY_BRANCH_NAME', value: "${VERIFY_BRANCH_NAME}"), string(name: 'REGISTRY', value: "${DOCKER_IMAGE_REGISTRY}"), string(name: 'XVSA_IMAGE_NAME', value: "${XVSA_IMAGE}"), string(name: 'VERIFY_IMAGE_NAME', value: "${VERIFY_IMAGE}"), string(name: 'XSCA_BRANCH_NAME', value: "${XSCA_BRANCH_NAME}"), string(name: 'XVSAPRO_BRANCH_NAME', value: "${XVSAPRO_BRANCH_NAME}"), string(name: 'NEXUS_REPO_ADDRESS_SH', value: "${NEXUS_REPO_ADDRESS_XVSA_SH}"), string(name: 'NEXUS_REPO_ADDRESS_SZ', value: "${NEXUS_REPO_ADDRESS_XVSA_SZ}"), string(name: 'NEXUS_REPO_USER', value: "${NEXUS_REPO_USER}"), password(name: 'NEXUS_REPO_PSW', value: "${NEXUS_REPO_PSW}"), string(name: 'XVSA_BUILD_SERVER', value: "${XVSA_BUILD_SERVER}")]
            }
        }
        stage("Packaging") {
            steps {
                build job: 'package_server_dev', parameters: [string(name: 'SDLC_REPO_BRANCH', value: 'devnew'), string(name: 'AGENT', value: "${AGENT}"), string(name: 'IMAGE_VERSION', value: "${BRANCH_NAME}"), string(name: 'PRODUCTSETUP_BRANCH_NAME', value: "${BRANCH_NAME}"), string(name: 'REGISTRY', value: "${DOCKER_IMAGE_REGISTRY}"), string(name: 'COMPANY', value: 'xcalibyte'), string(name: 'PRODUCT_NAME', value: 'xcalscan'), string(name: 'PRODUCT_RELEASE_VERSION', value: ''), string(name: 'OSSUTIL_PATH', value: '/home/sdlc/ossutil'), string(name: 'PRODUCT_TYPE', value: "${BRANCH_NAME}"), string(name: 'JFROG_PATH', value: '/home/xc5'), string(name: 'NEXUS_REPO_USER', value: "${NEXUS_REPO_USER}"), password(name: 'NEXUS_REPO_PSW', description: 'nexus repo password', value: "${NEXUS_REPO_PSW}"), string(name: 'NEXUS_REPO_ADDRESS_SH', value: "${NEXUS_REPO_ADDRESS_SH}"), string(name: 'NEXUS_REPO_ADDRESS_SZ', value: "${NEXUS_REPO_ADDRESS_SZ}"), string(name: 'AUTO_TEST_SERVER', value: "${AUTO_TEST_SERVER}"), string(name: 'NOTIFY_EMAILS', value: "${NOTIFY_EMAILS}")]
            }
        }
    }

    post('Email notification') {
        success {
            echo "Build and packaging success for release ${VERSION}, sending email to ${NOTIFY_EMAILS}"
            notifyBuild('SUCCESS')
        }
        failure {
            echo "Build and packaging failed for release ${VERSION}, sending email to ${NOTIFY_EMAILS}"
            notifyBuild('FAILED')
        }
    }
}


def notifyBuild(String buildStatus = 'STARTED') {
  // build status of null means successful
  def notifyEmails = "$NOTIFY_EMAILS"

  if (notifyEmails) {
    buildStatus = buildStatus ?: 'SUCCESS'
    attachLogs = buildStatus == 'SUCCESS' ? false: true

    // Default values
    def subject = "${buildStatus}: Job '${AGENT} - ${env.JOB_NAME} [${env.BUILD_NUMBER}] '"
    def details = '${SCRIPT, template="groovy-html.template"}'

    emailext (
        subject: subject,
        body: details,
        attachLog: attachLogs,
        mimeType: 'text/html',
        compressLog: true,
        from: 'Jenkins',
        to: notifyEmails
    )
  } else {
    echo "No NOTIFY_EMAILS specified, skip sending email notifiactions..."
  }
}
