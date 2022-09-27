pipeline {

    agent {
       node {
         label "${AGENT}"
       }
    }

    environment {
      xvsa_git_url = "gitlab-address/mastiff"
      verify_git_url = "gitlab-address/protect-verify-server"
      xvsapro_git_url = "gitlab-address/mastiff-package-protect"
      xvsapro_branch = "$XVSAPRO_BRANCH_NAME"
      xvsa_branch = "$XVSA_BRANCH_NAME"
      xsca_branch = "$XSCA_BRANCH_NAME"
      verify_branch = "$VERIFY_BRANCH_NAME"
      version = "$VERSION"
      registry = "$REGISTRY"
      xvsa_image_name = "$XVSA_IMAGE_NAME"
      verify_image_name = "$VERIFY_IMAGE_NAME"
      commit_id = ""
    }

    stages {
        stage('check dependencies') {
           steps {
            sh "which jq"
           }
        }
        stage('trace') {
           steps {
            sh "echo $PWD && ls -alF"
           }
        }
        stage('clone repository') {
           steps {
             dir('modules/xvsa/workdir') {
                 git credentialsId: 'xxx', branch: "${xvsa_branch}", url: "${xvsa_git_url}"
             }
           }
        }
        stage('checkout commitid') {
            steps {
              dir('modules/xvsa/workdir') {
                script {
                  //sh "echo ${env.commit_id}"
                  commit_id=getCommitID()
                }
              }
            }
        }
        stage('build xvsa/xsca and verify image') {
            steps {
              echo "Retrieving mastiff-package-protect"
              dir('modules/xvsa-with-verify/workdir/mastiff-package-protect') {
                 git credentialsId: 'xxx', branch: "${xvsapro_branch}", url: "${xvsapro_git_url}"
              }

              echo 'Retrieving xvsa...'
              sh "echo $PWD && ls -alF"
              dir('modules/xvsa-with-verify/workdir/xvsa') {
                sh "bash -x ../../retrieve_xvsa.sh $xvsa_branch $XVSA_BUILD_SERVER"
              }

              echo 'Building xsca...'
              dir('modules/xvsa-with-verify/workdir/xsca') {
                sh "cp ../../build_xsca.sh . && bash -x build_xsca.sh $xsca_branch"
              }

              echo "Building protect-verify"
              dir('modules/xvsa-with-verify/workdir/protect-verify') {
                 git credentialsId: 'xxx', branch: "${verify_branch}", url: "${verify_git_url}"
                 sh "cp ../../build_verify.sh . && bash -x build_verify.sh $verify_branch"
              }

              echo 'Building image..'
              sh "echo $PWD && ls -alF"
              dir('modules/xvsa-with-verify') {
                sh "bash InHouseBuild.sh $xvsa_image_name $verify_image_name $version $commit_id"
                //sh "echo 'exiting'; exit 1"
              }
            }
        }
        stage('push') {
            steps {
                echo 'Pushing....'
                withCredentials([usernamePassword(credentialsId: 'xxx', passwordVariable: 'password', usernameVariable:'user')]) {
                  sh """
                  docker login -u $user -p $password $registry
                  docker push $xvsa_image_name:$commit_id
                  docker push $verify_image_name:$commit_id
                  docker push $xvsa_image_name:$version
                  docker push $verify_image_name:$version
                  """
               }

            }
        }
        stage('versys') {
            steps {
                echo 'Register in version control system....'
                sh """
                    curl -X POST -F 'commitid=$commit_id' -F 'module=xvsa' http://127.0.0.1:6200/new
                """
            }
        }
        // stage('push to 39') {
        //     steps {
        //         echo 'Pushing images to 39....'
        //         withCredentials([usernamePassword(credentialsId: 'middleware-harbor-account', passwordVariable: 'password', usernameVariable:'user')]) {
        //           sh """
        //           docker login -u $user -p $password 'https://127.0.0.1:8129/'
        //           docker tag $xvsa_image_name:$VERSION 127.0.0.1:8129/xcalibyte/xcal.xvsa:latest
        //           docker tag $verify_image_name:$VERSION 127.0.0.1:8129/xcalibyte/xcal.pro-verify:latest
        //           docker push 127.0.0.1:8129/xcalibyte/xcal.xvsa:latest
        //           docker push 127.0.0.1:8129/xcalibyte/xcal.pro-verify:latest
        //           """
        //        }
        //     }
        // }

    }

    post {
        success {
            script {
                ver=getDate()
                echo "transmit xvsa package to nexus"
                sh """
                    set +e
                    cd '${WORKSPACE}/modules/xvsa-with-verify/workdir/xvsa/'
                    cp xvsa.tar.gz "xvsa-${ver}.tar.gz"
                    curl -v -u $NEXUS_REPO_USER:$NEXUS_REPO_PSW --upload-file "./xvsa-${ver}.tar.gz" $NEXUS_REPO_ADDRESS_SH
                    curl -v -u $NEXUS_REPO_USER:$NEXUS_REPO_PSW --upload-file "./xvsa-${ver}.tar.gz" $NEXUS_REPO_ADDRESS_SZ
                    rm "xvsa-${ver}.tar.gz"
                    cd -
                    set -e
                """
                echo "zip and transmit xsca package to nexus"
                sh """
                    set +e
                    cd '${WORKSPACE}/modules/xvsa-with-verify/workdir/xsca/'
                    zip -r "xsca-${ver}.zip" ./lib/*
                    curl -v -u $NEXUS_REPO_USER:$NEXUS_REPO_PSW --upload-file "./xsca-${ver}.zip" $NEXUS_REPO_ADDRESS_SH
                    curl -v -u $NEXUS_REPO_USER:$NEXUS_REPO_PSW --upload-file "./xsca-${ver}.zip" $NEXUS_REPO_ADDRESS_SZ
                    rm "xsca-${ver}.zip"
                    cd -
                    set -e
                """
            }
        }
    }
}

def getDate() {
    return sh(returnStdout: true, script: "date +%Y-%m-%d").trim()
}

def getCommitID() {
    return sh(returnStdout: true, script: "git rev-parse HEAD").trim()
}