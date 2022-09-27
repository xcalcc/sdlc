IMAGE_NAME=$1
VERSION=$2  # Image tag
BRANCH=$3
BUILD_ARGS=$4
ROOT_DIR=$(pwd)
MODULE_DIR="protect-relay"

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
  echo "\"protect-relay-server\":{
     \"GitRefId\":\"${GIT_REF_ID}\",
     \"Branch\":\"${BRANCH}\",
     \"Date\":\"${GIT_COMMIT_DATE}\"
      }" > ${ROOT_DIR}/VER
}

cd workdir && get_ver && cd ..

echo "Building image..."
docker build -t ${IMAGE_NAME}:${VERSION} -f InHouse.Dockerfile .
