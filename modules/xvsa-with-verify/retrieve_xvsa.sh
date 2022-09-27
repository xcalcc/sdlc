XVSA_BRANCH=$1
VERSION=$2 # Image tag
#BUILD_ARGS=$3
ROOT_DIR=$(pwd)
MODULE_DIR="xvsa"

INFO="[INFO]:"
WARN="[WARNING]:"
ERR="[ERROR]:"

#XVSA_BUILD_SERVER="http://127.0.0.1:7881"
#XVSA_BUILD_SERVER="http://127.0.0.1:7881" # Use ip to avoid resolution error
XVSA_BUILD_SERVER=${2:-"http://127.0.0.1:7881"}
TAR_FILE="xvsa.tar.gz"

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
  PROTECTION_ON="on"
  ASSERTION_ON="off"

  #if [ x"${GIT_REF}" = x"develop" ]; then
  #  ASSERTION_ON=off
  #fi

  ###

  START_BUILD_REQUEST="${XVSA_BUILD_SERVER}/api/v2/mastiff_builder_service/start_build?ref=${XVSA_BRANCH}&protect=${PROTECTION_ON}&assert=${ASSERTION_ON}"
  CID_RESPONSE=$(curl ${START_BUILD_REQUEST})
  if [ $? != 0 ]; then
    echo "Trigger build fail"
    exit 1
  fi
  CID=$(echo ${CID_RESPONSE} | jq ".cid" | tr -d "\"")

  STATUS_CHECK_CURL_URL="${XVSA_BUILD_SERVER}/api/v2/mastiff_builder_service/build_result?cid=${CID}"
  REQUEST_RESULT=$(curl ${STATUS_CHECK_CURL_URL})
  REQUEST_STATUS=$(echo ${REQUEST_RESULT} | jq ".status" | tr -d "\"")
  while [[ "${REQUEST_STATUS}"x == ""x || "${REQUEST_STATUS}"x == "pending"x ]]; do
    sleep 20s
    REQUEST_RESULT=$(curl ${STATUS_CHECK_CURL_URL})
    REQUEST_STATUS=$(echo ${REQUEST_RESULT} | jq ".status" | tr -d "\"")
  done
  if [ "${REQUEST_STATUS}"x = "failed"x ]; then
    echo "Build XVSA Failed, exiting..."
    exit 5
  fi

  #XVSA_URL=`echo ${REQUEST_RESULT} | jq ".path" | tr -d "\""`
  XVSA_URL="${XVSA_BUILD_SERVER}/api/v2/result/${CID}.tgz"
  curl ${XVSA_URL} -o ${TAR_FILE}

  ### Picking Git Ref ID
  echo "Grapping Git Ref ID In Directory: ${PWD}"
#  cp ${TAR_FILE} ./XVSA_TEMP/
  tar xf ${TAR_FILE} --strip-components=1
  echo "List Directory:"
  ls -lrt

#  cat ./COMPONENTS
#  cp ./COMPONENTS ${RESULT_DIR}/VER
#  #echo "CID:${CID}" >> ${RESULT_DIR}/VER
#  echo "Retarring XVSA..."
#  tar cf xvsa.tgz xvsa/* ${PUB_KEY} ${PRIV_KEY} ${CERT}
#
#  if [ $? != 0 ]; then
#    echo "${LOG_PREFIX_ERROR} Error compressing artifact, exiting..."
#    exit 2
#  fi
#
#  echo "Now Directory Structure:"
#  ls -lrt
#  mv xvsa.tgz ${RESULT_DIR}
#  #echo "XVSA: GitRefId:${GIT_REF_ID}, Branch:${BRANCH_INFO}"
#  #echo "XVSA: GitRefId:${GIT_REF_ID}, Branch:${BRANCH_INFO}" >> ${RESULT_DIR}/VER
#  cd .. && rm -rf XVSA_TEMP

}

retrieve_xvsa
