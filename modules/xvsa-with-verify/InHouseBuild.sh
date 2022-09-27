XVSA_IMAGE_NAME=$1
VERIFY_IMAGE_NAME=$2
VERSION=$3 # Image tag
BUILD_ARGS=$4
COMMIT_ID=$4

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

# get_ver() {
#   GIT_REF_ID=$(git show-ref | grep ${BRANCH} | head -n 1 | awk '{print $1}')
#   GIT_COMMIT_DATE=$(git log --pretty=format:"%cd" ${GIT_REF_ID} -1)
#   echo "\"mastiff\":{
#      \"GitRefId\":\"${GIT_REF_ID}\",
#      \"Branch\":\"${BRANCH}\",
#      \"Date\":\"${GIT_COMMIT_DATE}\"
#       }" >${ROOT_DIR}/VER
# }


echo "Building image..."
docker build -t ${XVSA_IMAGE_NAME}:${COMMIT_ID} -f InHouse.Xvsa.Dockerfile . && docker build -t ${VERIFY_IMAGE_NAME}:${COMMIT_ID} -f InHouse.Verify.Dockerfile .

docker tag ${XVSA_IMAGE_NAME}:${COMMIT_ID} ${XVSA_IMAGE_NAME}:${VERSION}
docker tag ${VERIFY_IMAGE_NAME}:${COMMIT_ID} ${VERIFY_IMAGE_NAME}:${VERSION}

