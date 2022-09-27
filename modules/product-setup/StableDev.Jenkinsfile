pipeline {

    agent {
      node {
        label "${AGENT}"
      }
    }

    environment {
      agent_label = "$AGENT"
      git_url = "gitlab-address/xcal-product-setup"
      branch = "$PRODUCTSETUP_BRANCH_NAME"
      image_version = "$IMAGE_VERSION"
      registry = "$REGISTRY"
      company = "xcalibyte"
      product_name = "$PRODUCT_NAME"
      product_type = "$PRODUCT_TYPE"  // dev, stage, release, cloud, etc
      ////product_release_version = "$PRODUCT_RELEASE_VERSION"
      sdlc_branch = "$SDLC_REPO_BRANCH"
      ossutil_path = "$OSSUTIL_PATH"
      jfrog_path = "$JFROG_PATH"
    }

    stages {
        stage('dependency check') {
           steps {
              script {
                if ("$agent_label" != "4.154-JenSlave") {
                  sh 'command -v sshpass'
                }
                if ("$product_type" == "dev") {
                  //sh "export PATH=$PATH:$ossutil_path"
                  //sh "command -v $ossutil_path/ossutil64"
                  sh "export PATH=$PATH:$jfrog_path"
                  sh "$jfrog_path/jfrog -v"
                }
              }
              script {
                if ("$PRODUCT_RELEASE_VERSION" != "") {
                  env.release_version = "$PRODUCT_RELEASE_VERSION"
                } else {
                  env.release_version = getDate()
                }
              }
              echo "$release_version"
              //sh "exit 1"
           }
        }
        stage('clone product setup') {
            steps {
               dir('modules/product-setup/workdir') {
                  git credentialsId: 'xxx', branch: "${branch}", url: "${git_url}"
               }
            }
        }
        stage('pull images') {
            steps {
                dir('modules/product-setup/workdir') {
                    echo 'Pulling image..'
                    withCredentials([usernamePassword(credentialsId: 'xxx', passwordVariable: 'password', usernameVariable:'user')]) {
                      sh """
                      docker login -u $user -p $password $registry
                      cp -r ../pull_images .
                      cp ../pull_images_commitid.sh .
                      bash -x pull_images_commitid.sh $registry $image_version $branch $release_version
                      """
                    }
                }
            }
        }
        stage('package') {
            steps {
              dir('modules/product-setup/workdir') {
                echo 'Wrapping image....'
                sh """
                cp -r ../pull_images .
                cp ../package.sh .
                bash -x package.sh $company $image_version $product_name $release_version
                """
              }
            }
        }
        stage('track sdlc') {
            steps {
              echo "Tracking sdlc repo"
              dir('modules/product-setup') {
                sh """
                bash -x getver.sh $sdlc_branch 'workdir/VER'
                """
              }
            }
        }
        stage('transmitting package') {
           steps {
             dir('modules/product-setup/workdir') {
               script {
                 if ("$product_type" == "dev") {
                   //echo 'Uploading package to OSS'
                   //sh "$ossutil_path/ossutil64 -u --parallel=5 cp $company-$product_name-$release_version-installer.tar.gz oss://xcalibyte/scan-server/xcalscan/dev-nightly/xcalibyte-xcalscan-dev-installer.tar.gz"
                   withCredentials([usernamePassword(credentialsId: 'xxx', passwordVariable: 'password', usernameVariable:'user')]) {
                     echo 'Uploading package to jfrog'
                     //sh "$jfrog_path/jfrog rt config --user=$user --password=$password --url=http://127.0.0.1:8082/artifactory --interactive=false"
                     sh "$jfrog_path/jfrog rt config --user=$user --password=$password --url=http://127.0.0.1:8082/artifactory --interactive=false"
                     sh "$jfrog_path/jfrog rt u $company-$product_name-$release_version-installer.tar.gz xc5art/xcalibyte-xcalscan-dev-installer.tar.gz --threads=6"
                   }
                 }
               }

               script {
                    echo "Making tmp workdir"
                    sh """
                    mkdir -p $product_name/$product_type/$release_version
                    mv VER VER.txt
                    mv $company-$product_name-$release_version-installer.tar.gz VER.txt $product_name/$product_type/$release_version
                    """
               }

               script {
                 echo "Transmitting package"
                 if ("$agent_label" == "4.154-JenSlave") {
                    sh """
                    cp -r $product_name /xcal-artifacts/inhouse
                    """
                 } else {
                    withCredentials([usernamePassword(credentialsId: 'xxx', passwordVariable: 'password', usernameVariable:'user')]) {
                      sh """
                      sshpass -p $password scp -r $product_name $user@127.0.0.1:/xcal-artifacts/inhouse
                      """
                 }
               }
             }
           }
        }
    }

}
}


def getCommitDate(refId) {
  //def refId = refId
  return sh(returnStdout: true, script: "git log --pretty=format:\"%cd\" $refId -1")
}

def getRefId(branch) {
    //def branch = branch
    return sh(returnStdout: true, script: "git show-ref | grep $branch | head -n 1 | awk '{print \$1}'")
}

def getDate() {
    return sh(returnStdout: true, script: "date +%Y-%m-%d").trim()
}