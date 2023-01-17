#!/bin/bash

# IBM GSI Ecosystem Lab

SCRIPT_DIR="$(cd $(dirname "$0"); pwd -P)"
SRC_DIR="${SCRIPT_DIR}/automation"
STOP_FILE="${SCRIPT_DIR}/.stop"

AUTOMATION_BASE=$(basename "${SCRIPT_DIR}")

if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
  echo "Usage: launch.sh [{docker cmd}] [--pull]"
  echo "  where:"
  echo "    {docker cmd} is the docker command that should be used (e.g. docker, podman). Defaults to docker"
  echo "    --pull is a flag indicating the latest version of the container image should be pulled"
  exit 0
fi

# Clean up stop file if it exists (this is used for flow control with container)
if [[ -e $STOP_FILE ]]; then
  rm -f $STOP_FILE
fi

DOCKER_CMD="docker"
if [[ -n "$1" ]] && [[ "$1" != "--pull" ]]; then
  DOCKER_CMD="${1:-docker}"
fi

if [[ ! -d "${SRC_DIR}" ]]; then
  SRC_DIR="${SCRIPT_DIR}"
fi

#DOCKER_IMAGE="quay.io/cloudnativetoolkit/cli-tools:v1.2-v2.2.12"
DOCKER_IMAGE="quay.io/cloudnativetoolkit/cli-tools-ibmcloud:v1.2-v0.6.1"
#AWS DOCKER_IMAGE="quay.io/cloudnativetoolkit/cli-tools-aws:v1.2-v0.3.12"
#AZURE DOCKER_IMAGE="quay.io/cloudnativetoolkit/cli-tools-azure:v1.2-v0.4.12"

SUFFIX=$(echo $(basename ${SCRIPT_DIR}) | base64 | sed -E "s/[^a-zA-Z0-9_.-]//g" | sed -E "s/.*(.{5})/\1/g")
CONTAINER_NAME="ibmcloud-${SUFFIX}"

echo "Cleaning up old container: ${CONTAINER_NAME}"

${DOCKER_CMD} kill ${CONTAINER_NAME} 1> /dev/null 2> /dev/null
${DOCKER_CMD} rm ${CONTAINER_NAME} 1> /dev/null 2> /dev/null

ARG_ARRAY=( "$@" )

if [[ " ${ARG_ARRAY[*]} " =~ " --pull " ]]; then
  echo "Pulling container image: ${DOCKER_IMAGE}"
  ${DOCKER_CMD} pull "${DOCKER_IMAGE}"
fi


ENV_VARS=""
if [[ -f "credentials.properties" ]]; then
  echo "parsing credentials.properties..."
  props=$(grep -v '^#' credentials.properties)
  while read line ; do
    #remove export statement prefixes
    CLEAN="$(echo $line | sed 's/export //' )"

    #parse key-value pairs
    IFS=' =' read -r KEY VALUE <<< ${CLEAN//\"/ }

    # don't add an empty key
    if [[ -n "${KEY}" ]]; then
      ENV_VARS="-e $KEY=$VALUE $ENV_VARS"
    fi
  done <<< "$props"
fi

OS=$(uname)

echo -n "Setup workspace (y/n) [Y]: "
read SETUP
echo


echo "Initializing container ${CONTAINER_NAME} from ${DOCKER_IMAGE}"
if [[ "${DOCKER_CMD}" == "podman" ]]; then
  echo "Starting container with podman"
  ${DOCKER_CMD} run -itd --name ${CONTAINER_NAME} \
    -u "${UID}:0" \
    --device /dev/net/tun --cap-add=NET_ADMIN \
    -v "${SRC_DIR}:/terraform" \
    -v "workspace-${AUTOMATION_BASE}-${UID}:/workspaces" \
    ${ENV_VARS} \
    -w /terraform \
    ${DOCKER_IMAGE}
elif [[ "${OS}" == "Linux" ]]; then 
  echo "Starting container with ${DOCKER_CMD} on Linux"
  ${DOCKER_CMD} run -itd --name ${CONTAINER_NAME} \
    --device /dev/net/tun --cap-add=NET_ADMIN \
    -v "${SRC_DIR}:/terraform" \
    -v "workspace-${AUTOMATION_BASE}-${UID}:/workspaces" \
    ${ENV_VARS} \
    -w /terraform \
    ${DOCKER_IMAGE}
else
  ${DOCKER_CMD} run -itd --name ${CONTAINER_NAME} \
    -u "${UID}:0" \
    --device /dev/net/tun --cap-add=NET_ADMIN \
    -v "${SRC_DIR}:/terraform" \
    -v "workspace-${AUTOMATION_BASE}-${UID}:/workspaces" \
    ${ENV_VARS} \
    -w /terraform \
    ${DOCKER_IMAGE}
fi

if [[ "$(echo $SETUP | tr '[:lower:]' '[:upper:]' )" == "Y" ]] || [[ -z $SETUP ]]; then
  
    ${DOCKER_CMD} exec -it -w /terraform ${CONTAINER_NAME} sh -c "cd /terraform ; /terraform/setup-workspace.sh -i" 

    if [[ -e $STOP_FILE ]]; then
      rm -f $STOP_FILE
      exit 1;
    fi

    echo -n "Build environment (only yes will be accepted) : "
    read BUILD

    if [[ "$(echo $BUILD | tr '[:lower:]' '[:upper:]' )" == "YES" ]]; then
      ${DOCKER_CMD} exec -it -w /workspaces/current ${CONTAINER_NAME} sh -c "./apply.sh -a"
    else
      echo
      echo "Attaching to running container..."
      echo
      echo "Run \"cd /workspaces/current && ./apply.sh -a\" to start build."
    fi
else
    echo "Attaching to running container..."
fi

${DOCKER_CMD} attach ${CONTAINER_NAME}
