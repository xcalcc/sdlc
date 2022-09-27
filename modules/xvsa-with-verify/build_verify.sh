BRANCH=$1
ROOT_DIR=$(pwd)

get_ver() {
  GIT_REF_ID=$(git show-ref | grep ${BRANCH} | head -n 1 | awk '{print $1}')
  GIT_COMMIT_DATE=$(git log --pretty=format:"%cd" ${GIT_REF_ID} -1)
  echo "\"protect-verify-server\":{
     \"GitRefId\":\"${GIT_REF_ID}\",
     \"Branch\":\"${BRANCH}\",
     \"Date\":\"${GIT_COMMIT_DATE}\"
      }" >${ROOT_DIR}/VER
}

get_ver &&
  cd complete &&
  ./mvnw clean package -Dmaven.test.skip=true
#get_ver &&
#  build -t ${IMAGE_NAME}:${VERSION} -f InHouse.Dockerfile .
