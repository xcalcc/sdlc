REGISTRY=$1
VERSION=$2  # Image tag
BRANCH=$3
PRODUCT_RELEASE_VERSION=$4
BUILD_ARGS=$4

INFO="[INFO]:"
WARN="[WARNING]:"
ERR="[ERROR]:"

IMAGE_PREFIX="xcal"
THIRD_PARTY_IMAGE_LIST=()   # Third party images to be packaged
XCALSCAN_IMAGE_LIST=()      # Xcalscan images to be packaged
PACKAGED_IMAGE_LIST_FILE="pull_images/image.list"
XCALSCAN_IMAGE_LIST_FILE="pull_images/xcalscan_images.txt"
THIRD_PARTY_IMAGE_LIST_FILE="pull_images/third_party_images.txt"

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
  echo "\"xcal-product-setup\":{
     \"GitRefId\":\"${GIT_REF_ID}\",
     \"Branch\":\"${BRANCH}\",
     \"Date\":\"${GIT_COMMIT_DATE}\"
      }" > VER
}

pull_third_party_images() {
  t_images=$(cat $THIRD_PARTY_IMAGE_LIST_FILE)
  for t_image in ${t_images[@]}; do
    name=$(echo ${t_image} | tr "=" " " | awk '{print $1}')
    source=$(echo ${t_image} | tr "=" " " | awk '{print $2}')
    echo "$INFO Pulling third-party image $name from $source"
    docker pull $source &&
      docker tag $source "${IMAGE_PREFIX}.${name}:${PRODUCT_RELEASE_VERSION}" &&
      THIRD_PARTY_IMAGE_LIST+=("${IMAGE_PREFIX}.${name}:${PRODUCT_RELEASE_VERSION}")
    if [ $? -ne 0 ]; then
      echo "$ERR Pulling third-party image $name from $source failed."
      exit 1
    fi
  done
}

gen_valid_xcalscan_images() {
  stableBOM=$(curl http://127.0.0.1:6200/getstablebom)
  BOM=$(echo $stableBOM | sed 's/ //g')
  BOM2=$(echo $BOM | sed 's/"//g')
  array=(${BOM2//,/ })
  if [ -f "valid_xcalscan_images.txt" ]; then
    rm valid_xcalscan_images.txt
  fi
  for var in ${array[@]}
  do
    row=(${var//:/ })
    case ${row[0]} in
      webmain)
        echo main-service=harbor.xcalibyte.co/xcalscan/xcal.main-service:${row[1]} >> valid_xcalscan_images.txt
        ;; 
      webpage)
        echo webfrontend=harbor.xcalibyte.co/xcalscan/xcal.webfrontend:${row[1]} >> valid_xcalscan_images.txt
        ;;
      xvsa)
        echo xvsa=harbor.xcalibyte.co/xcalscan/xcal.xvsa:${row[1]} >> valid_xcalscan_images.txt
        echo pro-verify=harbor.xcalibyte.co/xcalscan/xcal.pro-verify:${row[1]} >> valid_xcalscan_images.txt
        ;;
      scanservice)
        echo scan-service=harbor.xcalibyte.co/xcalscan/xcal.scan-service:${row[1]} >> valid_xcalscan_images.txt
        ;;
      ruleservice)
        echo rule-service=harbor.xcalibyte.co/xcalscan/xcal.rule-service:${row[1]} >> valid_xcalscan_images.txt
        ;;
      protectrelay)
        echo pro-relay=harbor.xcalibyte.co/xcalscan/xcal.pro-relay:${row[1]} >> valid_xcalscan_images.txt
        ;;
      fileservice)
        echo file-service=harbor.xcalibyte.co/xcalscan/xcal.file-service:${row[1]} >> valid_xcalscan_images.txt
        ;;
      database)
        echo database=harbor.xcalibyte.co/xcalscan/xcal.database:${row[1]} >> valid_xcalscan_images.txt
        ;;
      apigateway)
        echo apigateway=harbor.xcalibyte.co/xcalscan/xcal.apigateway:${row[1]} >> valid_xcalscan_images.txt
        ;;
      notificationservice)
        echo notification-service=harbor.xcalibyte.co/xcalscan/xcal.notification-service:${row[1]} >> valid_xcalscan_images.txt
        ;;
    esac
  done 
}

pull_xcalscan_images() {
  gen_valid_xcalscan_images
  #cat $XCALSCAN_IMAGE_LIST_FILE | sed "s#REGISTRY#${REGISTRY}#" | \
  #  sed "s#VERSION#${VERSION}#" > valid_xcalscan_images.txt
  x_images=$(cat valid_xcalscan_images.txt)
  for x_image in ${x_images[@]}; do
    name=$(echo ${x_image} | tr "=" " " | awk '{print $1}')
    source=$(echo ${x_image} | tr "=" " " | awk '{print $2}')
    echo "$INFO Pulling xcalscan image $name from $source"
    docker pull $source &&
      docker tag $source "${IMAGE_PREFIX}.${name}:${PRODUCT_RELEASE_VERSION}" &&
      XCALSCAN_IMAGE_LIST+=("${IMAGE_PREFIX}.${name}:${PRODUCT_RELEASE_VERSION}")
    if [ $? -ne 0 ]; then
      echo "$ERR Pulling xcalscan image $name from $source failed."
      exit 1
    fi
  done
}

grab_ver() {
  get_ver
  for xcalscan_image in ${XCALSCAN_IMAGE_LIST[@]}; do
    docker run --rm $xcalscan_image cat /VER >> VER
    if [ $? -ne 0 ]; then
      echo "$ERR Grabing $xcalscan_image VER failed."
      #exit 1
    fi
  done
}

write_image_list_to_file() {
  # clean PACKAGED_IMAGE_LIST_FILE first
  echo "cleaning $PACKAGED_IMAGE_LIST_FILE"
  echo "" > $PACKAGED_IMAGE_LIST_FILE

  for third_party_image in ${THIRD_PARTY_IMAGE_LIST[@]}; do
    echo $third_party_image >> $PACKAGED_IMAGE_LIST_FILE
  done
  for xcalscan_image in ${XCALSCAN_IMAGE_LIST[@]}; do
    echo $xcalscan_image >> $PACKAGED_IMAGE_LIST_FILE
  done
}

main() {
  pull_third_party_images
  status_check $? "Pulling third_party_image"
  pull_xcalscan_images
  status_check $? "Pulling xcalscan_image"
  grab_ver
  status_check $? "Grabing ver"
  write_image_list_to_file
  status_check $? "write_image_list_to_file"
}

# TODO: check completeness

main
