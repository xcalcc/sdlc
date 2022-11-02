pipeline {
    agent {
        label "4.154-JenSlave"
    }

    environment {
        AGENT = "4.154-JenSlave"
        VERSION = "${VERSION}"
        BRANCH_NAME = "${BRANCH_NAME}"
        REF_BRANCH = "${REF_BRANCH}"
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
        XVSA_BUILD_SERVER = "${XVSA_BUILD_SERVER}"
        PRODUCT_RELEASE_VERSION = "${PRODUCT_RELEASE_VERSION}"
        IMAGE_VERSION = "${IMAGE_VERSION}"
        PRODUCTSETUP_BRANCH_NAME = "${PRODUCTSETUP_BRANCH_NAME ?: 'dev'}"
        XSCA_BRANCH_NAME = "${XSCA_BRANCH_NAME ?: 'dev'}"
        XVSAPRO_BRANCH_NAME = "${XVSAPRO_BRANCH_NAME ?: 'dev'}"
        VERIFY_BRANCH_NAME = "${VERIFY_BRANCH_NAME ?: 'dev'}"

        NOTIFY_EMAILS = "${NOTIFY_EMAILS}"
    }
    
    stages {
        stage("api gateway") {
            steps {
                script {
                    if (env.BUILD_API_GATEWAY == "true") {
                        build job: 'build_apigateway_rel', parameters: [string(name: 'SDLC_REPO_BRANCH', value: 'devnew'), string(name: 'AGENT', value: "$AGENT"), string(name: 'VERSION', value: "${VERSION}"), string(name: 'APIGATEWAY_BRANCH_NAME', value: "${BRANCH_NAME}"), string(name: 'REGISTRY', value: "${DOCKER_IMAGE_REGISTRY}"), string(name: 'IMAGE_NAME', value: "${API_GATEWAY_IMAGE}"), string(name: 'REF_BRANCH', value: "${REF_BRANCH}")]
                    } else {
                        echo "Skipping build api gateway"
                    }
                }
            }
        }
        stage("database") {
            steps {
                script {
                    if (env.BUILD_DATABASE == "true") {
                        build job: 'build_database_rel', parameters: [string(name: 'SDLC_REPO_BRANCH', value: 'devnew'), string(name: 'AGENT', value: "$AGENT"), string(name: 'VERSION', value: "${VERSION}"), string(name: 'DATABASE_BRANCH_NAME', value: "${BRANCH_NAME}"), string(name: 'REGISTRY', value: "${DOCKER_IMAGE_REGISTRY}"), string(name: 'IMAGE_NAME', value: "${DATABASE_IMAGE}"), string(name: 'REF_BRANCH', value: "${REF_BRANCH}")]
                    } else {
                        echo "Skipping build db"
                    }
                }
            }
        }
        stage("file service") {
            steps {
                script {
                    if (env.BUILD_FILE_SERVICE == "true") {
                        build job: 'build_fileservice_rel', parameters: [string(name: 'SDLC_REPO_BRANCH', value: 'devnew'), string(name: 'AGENT', value: "$AGENT"), string(name: 'VERSION', value: "${VERSION}"), string(name: 'REGISTRY', value: "${DOCKER_IMAGE_REGISTRY}"), string(name: 'IMAGE_NAME', value: "${FILE_SERVICE_IMAGE}"), string(name: 'FILE_SERVICE_BRANCH_NAME', value: "${REF_BRANCH}")]
                    } else {
                        echo "Skipping build file service"
                    }
                }
            }
        }
        stage("notification service") {
            steps {
                script {
                    if (env.BUILD_NOTIFICATION_SERVICE == "true") {
                        build job: 'build_notificationservice_rel', parameters: [string(name: 'SDLC_REPO_BRANCH', value: 'devnew'), string(name: 'AGENT', value: "$AGENT"), string(name: 'VERSION', value: "${VERSION}"), string(name: 'BRANCH_NAME', value: "${BRANCH_NAME}"), string(name: 'REGISTRY', value: "${DOCKER_IMAGE_REGISTRY}"), string(name: 'IMAGE_NAME', value: "${NOTIFICATION_SERVICE_IMAGE}"), string(name: 'REF_BRANCH', value: "${REF_BRANCH}")]
                    } else {
                        echo "Skipping build notification service"
                    }
                }
            }
        }
        stage("protect relay") {
            steps {
                script {
                    if (env.BUILD_PROTECT_RELAY == "true") {
                        build job: 'build_protectrelay_rel', parameters: [string(name: 'SDLC_REPO_BRANCH', value: 'devnew'), string(name: 'AGENT', value: "$AGENT"), string(name: 'VERSION', value: "${VERSION}"), string(name: 'RELAY_BRANCH_NAME', value: "${BRANCH_NAME}"), string(name: 'REGISTRY', value: "${DOCKER_IMAGE_REGISTRY}"), string(name: 'IMAGE_NAME', value: "${BUILD_PROTECT_RELAY_IMAGE}"), string(name: 'REF_BRANCH', value: "${REF_BRANCH}")]
                    } else {
                        echo "Skipping build protect relay"
                    }
                }
            }
        }
        stage("rule service") {
            steps {
                script {
                    if (env.BUILD_RULE_SERVICE == "true") {
                        build job: 'build_ruleservice_rel', parameters: [string(name: 'SDLC_REPO_BRANCH', value: 'devnew'), string(name: 'AGENT', value: "$AGENT"), string(name: 'VERSION', value: "${VERSION}"), string(name: 'BRANCH_NAME', value: "${BRANCH_NAME}"), string(name: 'REGISTRY', value: "${DOCKER_IMAGE_REGISTRY}"), string(name: 'IMAGE_NAME', value: "${RULE_SERVICE_IMAGE}"), string(name: 'REF_BRANCH', value: "${REF_BRANCH}")]
                    } else {
                        echo "Skipping build rule service"
                    }
                }
            }
        }
        stage("scan service") {
            steps {
                script {
                    if (env.BUILD_SCAN_SERVICE == "true") {
                        build job: 'build_scanservice_rel', parameters: [string(name: 'SDLC_REPO_BRANCH', value: 'devnew'), string(name: 'AGENT', value: "$AGENT"), string(name: 'VERSION', value: "${VERSION}"), string(name: 'SCANSERVICE_BRANCH_NAME', value: "${BRANCH_NAME}"), string(name: 'REGISTRY', value: "${DOCKER_IMAGE_REGISTRY}"), string(name: 'IMAGE_NAME', value: "${SCAN_SERVICE_IMAGE}"), string(name: 'REF_BRANCH', value: "${REF_BRANCH}")]
                    } else {
                        echo "Skipping build scan service"
                    }
                }
            }
        }
        stage("webmain api") {
            steps {
                script {
                    if (env.BUILD_WEB_API_SERVICE == "true") {
                        build job: 'build_webmain_rel', parameters: [string(name: 'SDLC_REPO_BRANCH', value: 'devnew'), string(name: 'AGENT', value: "$AGENT"), string(name: 'VERSION', value: "${VERSION}"), string(name: 'MAINSERVICE_BRANCH_NAME', value: "${BRANCH_NAME}"), string(name: 'REGISTRY', value: "${DOCKER_IMAGE_REGISTRY}"), string(name: 'IMAGE_NAME', value: "${MAIN_API_SERVICE_IMAGE}"), string(name: 'M2_DIR', value: '/home/xc5/build_use_m2'), string(name: 'REF_BRANCH', value: "${REF_BRANCH}")]
                    } else {
                        echo "Skipping build web main api"
                    }
                }
            }
        }
        stage("web ui") {
            steps {
                script {
                    if (env.BUILD_WEB_UI == "true") {
                        build job: 'build_webpage_rel', parameters: [string(name: 'SDLC_REPO_BRANCH', value: 'devnew'), string(name: 'AGENT', value: "$AGENT"), string(name: 'VERSION', value: "${VERSION}"), string(name: 'WEBFRONTEND_BRANCH_NAME', value: "${BRANCH_NAME}"), string(name: 'REGISTRY', value: "${DOCKER_IMAGE_REGISTRY}"), string(name: 'IMAGE_NAME', value: "${WEB_UI_SERVICE_IMAGE}"), string(name: 'REF_BRANCH', value: "${REF_BRANCH}")]
                    } else {
                        echo "Skipping build web ui"
                    }
                }
            }
        }
        stage("xvsa") {
            steps {
                script {
                    if (env.BUILD_XVSA == "true") {
                        build job: 'build_xvsa_with_verify_rel', parameters: [string(name: 'SDLC_REPO_BRANCH', value: 'devnew'), string(name: 'AGENT', value: "$AGENT"), string(name: 'VERSION', value: "${VERSION}"), string(name: 'XVSA_BRANCH_NAME', value: "${BRANCH_NAME}"), string(name: 'VERIFY_BRANCH_NAME', value: "${VERIFY_BRANCH_NAME}"), string(name: 'REGISTRY', value: "${DOCKER_IMAGE_REGISTRY}"), string(name: 'XVSA_IMAGE_NAME', value: "${XVSA_IMAGE}"), string(name: 'VERIFY_IMAGE_NAME', value: "${VERIFY_IMAGE}"), string(name: 'XVSAPRO_BRANCH_NAME', value: "${XVSAPRO_BRANCH_NAME}"), string(name: 'XSCA_BRANCH_NAME', value: "${XSCA_BRANCH_NAME}"), string(name: 'REF_BRANCH', value: "${REF_BRANCH}"), string(name: 'NEXUS_REPO_USER', value: "${NEXUS_REPO_USER}"), password(name: 'NEXUS_REPO_PSW', value: "${NEXUS_REPO_PSW}"), string(name: 'NEXUS_REPO_ADDRESS_SH', value: "${NEXUS_REPO_ADDRESS_XVSA_SH}"), string(name: 'NEXUS_REPO_ADDRESS_SZ', value: "${NEXUS_REPO_ADDRESS_XVSA_SZ}"), string(name: 'XVSA_BUILD_SERVER', value: "${XVSA_BUILD_SERVER}")]
                    } else {
                        echo "Skipping build xvsa"
                    }
                }
            }
        }
        stage("Packaging") {
            steps {
                build job: 'package_xcalscan_rel', parameters: [string(name: 'PRODUCT_RELEASE_VERSION', value: "${PRODUCT_RELEASE_VERSION}"), string(name: 'IMAGE_VERSION', value: "${IMAGE_VERSION}"), string(name: 'AGENT', value: "$AGENT"), string(name: 'SDLC_REPO_BRANCH', value: 'devnew'), string(name: 'PRODUCTSETUP_BRANCH_NAME', value: "${PRODUCTSETUP_BRANCH_NAME}"), string(name: 'COMPANY', value: 'xcalibyte'), string(name: 'PRODUCT_NAME', value: 'xcalscan'), string(name: 'PRODUCT_TYPE', value: 'release'), string(name: 'REGISTRY', value: "${DOCKER_IMAGE_REGISTRY}"), string(name: 'NEXUS_REPO_USER', value: "${NEXUS_REPO_USER}"), password(name: 'NEXUS_REPO_PSW', value: "${NEXUS_REPO_PSW}"), string(name: 'NEXUS_REPO_ADDRESS_SH', value: "${NEXUS_REPO_ADDRESS_SH}"), string(name: 'NEXUS_REPO_ADDRESS_SZ', value: "${NEXUS_REPO_ADDRESS_SZ}")]
            }
        }
    }

    
    post ('Email notification') {
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