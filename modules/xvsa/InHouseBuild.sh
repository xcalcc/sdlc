IMAGE_NAME=$1
VERSION=$2 # Image tag
BRANCH=$3
BUILD_ARGS=$4
ROOT_DIR=$(pwd)
MODULE_DIR="xvsa"

INFO="[INFO]:"
WARN="[WARNING]:"
ERR="[ERROR]:"

status_check() {
  ret=$1
  prompt=$2

  if [ ${ret} != 0 ]; then
    logger "${ERR} ${prompt}...failed"
    exit 1
  else
    logger "${INFO} ${prompt}...ok"
  fi
}

get_ver() {
  GIT_REF_ID=$(git show-ref | grep ${BRANCH} | head -n 1 | awk '{print $1}')
  GIT_COMMIT_DATE=$(git log --pretty=format:"%cd" ${GIT_REF_ID} -1)
  echo "\"mastiff\":{
     \"GitRefId\":\"${GIT_REF_ID}\",
     \"Branch\":\"${BRANCH}\",
     \"Date\":\"${GIT_COMMIT_DATE}\"
      }" >${ROOT_DIR}/VER
}

#get_ver

retrieve_xvsa() {
  PUB_KEY="ca.pub.signed"
  PRIV_KEY="test.ca.priv.pkcs8.pem"
  CERT="middle.v1"

  ### Protection and Assertion Switch
  PROTECTION_ON=off
  ASSERTION_ON=off
  if [ x"${GIT_REF}" = x"develop" ]; then
    PROTECTION_ON=on
    ASSERTION_ON=on
  fi
  ###

  START_BUILD_REQUEST="http://127.0.0.1:7888/api/v2/mastiff_builder_service/start_build?ref=${GIT_REF}&protect=${PROTECTION_ON}&assert=${ASSERTION_ON}"
  CID_RESPONSE=$(curl ${START_BUILD_REQUEST})
  CID=$(echo ${CID_RESPONSE} | jq ".cid" | tr -d "\"")

  STATUS_CHECK_CURL_URL="http://127.0.0.1:7888/api/v2/mastiff_builder_service/build_result?cid=${CID}"
  REQUEST_RESULT=$(curl ${STATUS_CHECK_CURL_URL})
  REQUEST_STATUS=$(echo ${REQUEST_RESULT} | jq ".status" | tr -d "\"")
  while [[ "${REQUEST_STATUS}" == "" || "${REQUEST_STATUS}" == "pending" ]]; do
    sleep 20s
    REQUEST_RESULT=$(curl ${STATUS_CHECK_CURL_URL})
    REQUEST_STATUS=$(echo ${REQUEST_RESULT} | jq ".status" | tr -d "\"")
  done
  if [ "${REQUEST_STATUS}" = "failed" ]; then
    echo "Build XVSA Failed, exiting..."
    echo "Build XVSA Failed, exiting..." >>${RESULT_DIR}/XVSA.FAILED
    exit 20
  fi

  XVSA_URL=$(echo ${REQUEST_RESULT} | jq ".path" | tr -d "\"")
  curl ${XVSA_URL} -o ${RESULT_DIR}/${TAR_FILE}

  ### Picking Git Ref ID
  echo "Grapping Git Ref ID In Directory: ${PWD}"
  mkdir XVSA_TEMP
  cp ${RESULT_DIR}/${TAR_FILE} ./XVSA_TEMP/
  cd XVSA_TEMP
  tar xf .${TAR_FILE} --strip-components=1
  echo "List Directory:"
  ls -lrt

  #GIT_REF_ID=`./bin/xvsa -vvv 2>&1 | grep "Internal revision" | awk '{printf $3}' | sed "s#([a-zA-Z]*.)##"`
  #BRANCH_INFO=`./bin/xvsa -vvv 2>&1 | grep "Internal revision" | awk '{printf $3}' | sed "s#^.\{41\}##g" | sed "s#)##"`
  cat ./COMPONENTS
  cp ./COMPONENTS ${RESULT_DIR}/VER
  #echo "CID:${CID}" >> ${RESULT_DIR}/VER
  echo "Retarring XVSA..."
  tar cf xvsa.tgz xvsa/* ${PUB_KEY} ${PRIV_KEY} ${CERT}
}

#retrieve_xvsa

echo "Building image..."
docker build -t ${IMAGE_NAME}:${VERSION} -f InHouse.Dockerfile .
