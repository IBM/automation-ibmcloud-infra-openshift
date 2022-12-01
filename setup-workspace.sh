#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname $0); pwd -P)

FLAVOR=""
STORAGE=""
PREFIX_NAME=""
REGION="us-east"
GIT_HOST=""
BANNER=""
WORKER="bx2.16x64"
SUBNETS="3"
NODE_QTY="1"
OCP_VERSION="4.8"

METADATA_FILE="${SCRIPT_DIR}/ibmcloud-metadata.yaml"
INTERACT=0   # Flag to determine whether to use interactive mode

function usage()
{
   echo "Creates a workspace folder and populates it with architectures."
   echo
   echo "Usage: setup-workspace.sh [-f FLAVOR] -s STORAGE [-n PREFIX_NAME] [-r REGION] [-g GIT_HOST]"
   echo "  options:"
   echo "   -f   (optional) the flavor to use (quickstart)"
   echo "   -s   the storage option to use (portworx or odf or none)"
   echo "   -n   (optional) prefix that should be used for all variables"
   echo "   -r   (optional) the region where the infrastructure will be provisioned"
   echo "   -b   (optional) the banner text that should be shown at the top of the cluster"
   echo "   -g   (optional) the git host that will be used for the gitops repo. If left blank gitea will be used by default. (Github, Github Enterprise, Gitlab, Bitbucket, Azure DevOps, and Gitea servers are supported)"
   echo "   -i   interactive mode for value input and validation."
   echo "   -h   Print this help"
   echo
}

# Get the options
while getopts ":f:s:n:r:b:g:hi" option; do
   case $option in
      h) # display Help
         usage
         exit 1;;
      i) # Interactive mode
         INTERACT=1;;
      f) # Enter a name
         FLAVOR=$OPTARG;;
      s) # Enter a name
         STORAGE=$OPTARG;;
      n) # Enter a name
         PREFIX_NAME=$OPTARG;;
      r) # Enter a name
         REGION=$OPTARG;;
      g) # Enter a name
         GIT_HOST=$OPTARG;;
      b) # Enter a name
         BANNER=$OPTARG;;
     \?) # Invalid option
         echo "Error: Invalid option"
         Usage
         exit 1;;
   esac
done

function menu() {
    local item i=1 numItems=$#

    for item in "$@"; do
        printf '%s %s\n' "$((i++))" "$item"
    done >&2

    while :; do
        printf %s "${PS3-#? }" >&2
        read -r input
        if [[ -z $input ]]; then
            break
        elif (( input < 1 )) || (( input > numItems )); then
          echo "Invalid Selection. Enter number next to item, or return for default in square brackets." >&2
          continue
        fi
        break
    done

    if [[ -n $input ]]; then
        printf %s "${@: input:1}"
    fi
}

function interact() {
  local DEFAULT_FLAVOR="quickstart"
  local DEFAULT_STORAGE="odf"
  local DEFAULT_REGION="eu-gb"
  local DEFAULT_BANNER="$DEFAULT_FLAVOR"
  local DEFAULT_GITHOST="gitea"
  local MAX_PREFIX_LENGTH=5
  local MAX_BANNER_LENGTH=25
  local DEFAULT_WORKER_FLAVOR="bx2.16x64"
  local DEFAULT_SUBNETS="3"
  local DEFAULT_NODE_QTY="1"   # Nodes per subnet
  local DEFAULT_OCP_VERSION="4.8"

  IFS=$'\n'

  # Get flavor
  echo
  read -r -d '' -a FLAVORS < <(yq '.flavors[].name' $METADATA_FILE | sort -u)
  PS3="Select the architecture flavor [$(yq ".flavors[] | select(.code == \"$DEFAULT_FLAVOR\") | .name" $METADATA_FILE)]: "
  flavor=$(menu "${FLAVORS[@]}")
  case $flavor in
    '') FLAVOR="$DEFAULT_FLAVOR"; ;;
     *) FLAVOR="$(yq ".flavors[] | select(.name == \"$flavor\") | .code" $METADATA_FILE)"; ;;
  esac

  # Get storage
  echo
  read -r -d '' -a STORAGE_OPTIONS < <(yq '.storage[].name' $METADATA_FILE | sort -u)
  PS3="Select the storage [$(yq ".storage[] | select(.code == \"$DEFAULT_STORAGE\") | .name" $METADATA_FILE)]: "
  storage=$(menu "${STORAGE_OPTIONS[@]}")
  case $storage in
    '') STORAGE="$DEFAULT_STORAGE"; ;;
     *) STORAGE="$(yq ".storage[] | select(.name == \"$storage\") | .code" $METADATA_FILE)"; ;;
  esac

  # Get region
  echo
  read -r -d '' -a REGIONS < <(yq '.regions[].name' $METADATA_FILE | sort -u)
  PS3="Select the deployment area [$(yq ".regions[] | select(.code == \"$DEFAULT_REGION\") | .name" $METADATA_FILE)]: "
  region=$(menu "${REGIONS[@]}")
  case $region in
    '') REGION="$DEFAULT_REGION"; ;;
     *) REGION="$(yq ".regions[] | select(.name == \"$region\") | .code" $METADATA_FILE)"; ;;
  esac

  # Get OpenShift version
  echo
  read -r -d '' -a VERSIONS < <(yq '.ocp_versions[].name' $METADATA_FILE | sort -u)
  PS3="Select OpenShift Version [$DEFAULT_OCP_VERSION]: "
  version=$(menu "${VERSIONS[@]}")
  case $version in
    '') OCP_VERSION="$DEFAULT_OCP_VERSION"; ;;
     *) OCP_VERSION="$version"; ;;
  esac

  # Get worker node flavor
  echo
  read -r -d '' -a FLAVORS < <(yq '.worker_nodes.flavors[].name' $METADATA_FILE | sort -u)
  PS3="Select worker node flavor [$DEFAULT_WORKER_FLAVOR]: "
  worker_flavor=$(menu "${FLAVORS[@]}")
  case $worker_flavor in
    '') WORKER="$DEFAULT_WORKER_FLAVOR"; ;;
     *) WORKER="$worker_flavor"; ;;
  esac

  # Get subnet quantity
  while [[ -z $SUBNET_QTY ]]; do
    echo
    echo -n -e "Enter number of worker subnets (one per zone) [$DEFAULT_SUBNETS]: "
    read subnet_qty

    if [[ -n $subnet_qty ]]; then
      if [[ $subnet_qty =~ [1-3] ]]; then
        SUBNET_QTY="$subnet_qty"
      else
        echo "Invalid quantity. Must be between 1 and 3."
      fi
    elif [[ -z $subnet_qty ]]; then
      SUBNET_QTY="$DEFAULT_SUBNETS"
    fi
  done
  SUBNETS="$SUBNET_QTY"

  # Get number of worker nodes per subnet
  while [[ -z $NODES ]]; do
    echo
    echo -n -e "Enter the number of worker nodes per subnet/zone [$DEFAULT_NODE_QTY]: "
    read node_qty

    if [[ -n $node_qty ]]; then
      if [[ $node_qty =~ [1-9] ]]; then
        NODES="$node_qty"
      else
        echo "Invalid quantity. Must be between 1 and 9."
      fi
    elif [[ -z $node_qty ]]; then
      NODES="$DEFAULT_NODE_QTY"
    fi
  done
  NODE_QTY="$NODES"

  # Get name prefix
  local name=""
  name+="${FLAVOR:0:1}"
  name+="${STORAGE:0:1}-"
  chars=abcdefghijklmnopqrstuvwxyz0123456789
  for i in {1..3}; do
      name+=${chars:RANDOM%${#chars}:1}
  done


  while [[ -z $INPUT_NAME ]]; do
    echo
    echo -n -e "Enter name prefix [$name]: "
    read input

    if [[ -n $input ]]; then
      if [[ $input =~ [a-zA-Z0-9] ]] && (( ${#input} <= $MAX_PREFIX_LENGTH )) ; then
        INPUT_NAME=$input
      else
        echo "Invalid prefix name. Must be less than $MAX_PREFIX_LENGTH, not contain spaces and be alphanumeric characters only"
      fi
    elif [[ -z $input ]]; then
      INPUT_NAME=$name
    fi
  done

  if [[ -n $INPUT_NAME ]]; then
    PREFIX_NAME="${INPUT_NAME}"
  else
    PREFIX_NAME="${NAME}"
  fi

  # Get git host
  echo
  read -r -d '' -a GIT_HOST_OPTIONS < <(yq ".git_hosts[].name" $METADATA_FILE)
  PS3="Select GitOps Host Type [$(yq ".git_hosts[] | select(.code == \"$DEFAULT_GITHOST\") | .name" $METADATA_FILE)]: "
  githost=$(menu "${GIT_HOST_OPTIONS[@]}")
  case $githost in
    '') GIT_HOST_CODE="$DEFAULT_GITHOST"; ;;
     *) GIT_HOST_CODE="$(yq ".git_hosts[] | select(.name == \"$githost\") | .code" $METADATA_FILE)"; ;;
  esac

  if [[ -z $GIT_HOST_CODE ]]; then
    echo
    echo -n "Please enter hostname for $githost : "
    read GIT_HOST
  elif [[ $GIT_HOST_CODE == "gitea" ]]; then
    GIT_HOST=""
  else
    GIT_HOST=$GIT_HOST_CODE
  fi

  # Get banner
  DEFAULT_BANNER="$FLAVOR"
  echo
  echo -n "Enter title for console banner [$DEFAULT_BANNER]: "
  read BANNER_NAME

  if [[ -n $BANNER_NAME ]]; then
    BANNER="${BANNER_NAME}"
  else
    BANNER="${DEFAULT_BANNER}"
  fi  

  echo
  echo "Setting up workspace with the following"
  echo "Architecture (Flavor) = $FLAVOR"
  echo "Region/Location       = $REGION"
  echo "OpenShift Version     = $OCP_VERSION"
  echo "Worker Node Flavor    = $WORKER"
  echo "Worker Subnets        = $SUBNETS"
  echo "Worker Nodes / Subnet = $NODE_QTY"
  echo "Storage               = $STORAGE"
  echo "GitOps Host           = $GIT_HOST"
  echo "Console Banner Title  = $BANNER"

  echo -n "Confirm setup workspace with these settings (Y/N) [Y]: "
  read confirm

  if [[ -z $confirm ]]; then
    confirm="Y"
  fi

  if [[ ${confirm^} != "Y" ]]; then
    echo "Exiting without setting up environment" >&2
    touch ${SCRIPT_DIR}/.stop
    exit 0
  fi
}

if (( $INTERACT != 0 )); then
  interact
fi


if [[ -z "${FLAVOR}" ]]; then
  FLAVORS=($(find "${SCRIPT_DIR}" -maxdepth 1 -type d | grep "${SCRIPT_DIR}/" | sed -E "s~${SCRIPT_DIR}/~~g" | grep -E "^[0-9]-" | sort | sed -e "s/[0-9]-//g" | awk '{$1=toupper(substr($1,0,1))substr($1,2)}1'))

  PS3="Select the flavor: "

  select flavor in ${FLAVORS[@]}; do
    if [[ -n "${flavor}" ]]; then
      FLAVOR="${flavor}"
      break
    fi
  done

  FLAVOR_DIR="${REPLY}-$(echo "${FLAVOR}" | tr '[:upper:]' '[:lower:]')"
else
  FLAVORS=($(find "${SCRIPT_DIR}" -maxdepth 1 -type d | grep "${SCRIPT_DIR}/" | sed -E "s~${SCRIPT_DIR}/~~g" | sort | awk '{$1=toupper(substr($1,0,1))substr($1,2)}1'))

  for flavor in ${FLAVORS[@]}; do
    if [[ "$(echo "${flavor}" | tr '[:upper:]' '[:lower:]')" =~ ${FLAVOR} ]]; then
      FLAVOR_DIR="${flavor}"
      break
    fi
  done
fi

if [[ "${FLAVOR}" == "Advanced" ]]; then
  echo "  Advanced is currently not a supported flavor" >&2
  exit 1
fi

STORAGE_OPTIONS=($(find "${SCRIPT_DIR}/${FLAVOR_DIR}" -maxdepth 1 -type d -name "210-*" | grep "${SCRIPT_DIR}/${FLAVOR_DIR}/" | sed -E "s~${SCRIPT_DIR}/${FLAVOR_DIR}/~~g" | sort | cat - <(echo "none")))

if [[ -z "${STORAGE}" ]]; then

  PS3="Select the storage: "

  select storage in ${STORAGE_OPTIONS[@]}; do
    if [[ -n "${storage}" ]]; then
      STORAGE="${storage}"
      break
    fi
  done
else
  for storage in ${STORAGE_OPTIONS[@]}; do
    if [[ "${storage}" =~ ${STORAGE} ]]; then
      STORAGE="${storage}"
      break
    fi
  done
fi

WORKSPACES_DIR="${SCRIPT_DIR}/../workspaces"
WORKSPACE_DIR="${WORKSPACES_DIR}/current"

if [[ -d "${WORKSPACE_DIR}" ]]; then
  DATE=$(date "+%Y%m%d%H%M")
  mv "${WORKSPACE_DIR}" "${WORKSPACES_DIR}/workspace-${DATE}"
fi

mkdir -p "${WORKSPACE_DIR}"

WORKSPACE_DIR=$(cd "${WORKSPACE_DIR}"; pwd -P)

cd "${WORKSPACE_DIR}"

echo "Setting up workspace for ${FLAVOR} in ${WORKSPACE_DIR}"
echo "*****"

if [[ -n "${PREFIX_NAME}" ]]; then
  PREFIX_NAME="${PREFIX_NAME}"
fi

if [[ -z "${GIT_HOST}" ]]; then
  GITHOST_COMMENT="#"
fi

if [[ -z "${BANNER}" ]]; then
  BANNER="${FLAVOR}"
fi

cat "${SCRIPT_DIR}/terraform.tfvars.template-${FLAVOR,,}" | \
  sed "s/PREFIX/${PREFIX_NAME}/g" | \
  sed "s/BANNER/${BANNER}/g" | \
  sed "s/REGION/${REGION}/g" | \
  sed "s/WORKER/${WORKER}/g" | \
  sed "s/SUBNETS/${SUBNETS}/g" | \
  sed "s/NODE_QTY/${NODE_QTY}/g" | \
  sed "s/OCP_VERSION/${OCP_VERSION}/g" \
  > "${WORKSPACE_DIR}/cluster.tfvars"

if [[ ! -f "${WORKSPACE_DIR}/gitops.tfvars" ]]; then
  cat "${SCRIPT_DIR}/terraform.tfvars.template-gitops" | \
    sed -E "s/#(.*=\"GIT_HOST\")/${GITHOST_COMMENT}\1/g" | \
    sed "s/PREFIX/${PREFIX_NAME}/g"  | \
    sed "s/GIT_HOST/${GIT_HOST}/g" | \
    sed "s/FLAVOR/${FLAVOR}/g" \
    > "${WORKSPACE_DIR}/gitops.tfvars"
fi

cp "${SCRIPT_DIR}/apply-all.sh" "${WORKSPACE_DIR}/apply.sh"
cp "${SCRIPT_DIR}/plan-all.sh" "${WORKSPACE_DIR}/plan.sh"
cp "${SCRIPT_DIR}/destroy-all.sh" "${WORKSPACE_DIR}/destroy.sh"
cp "${SCRIPT_DIR}/check-vpn.sh" "${WORKSPACE_DIR}/check-vpn.sh"

cp -R "${SCRIPT_DIR}/${FLAVOR_DIR}/.mocks" "${WORKSPACE_DIR}"
cp "${SCRIPT_DIR}/${FLAVOR_DIR}/layers.yaml" "${WORKSPACE_DIR}"
cp "${SCRIPT_DIR}/${FLAVOR_DIR}/terragrunt.hcl" "${WORKSPACE_DIR}"

mkdir -p "${WORKSPACE_DIR}/bin"

echo "Looking for layers in ${SCRIPT_DIR}/${FLAVOR_DIR}"

find "${SCRIPT_DIR}/${FLAVOR_DIR}" -maxdepth 1 -type d | grep -vE "[.][.]/[.].*" | grep -v workspace | sort | \
  while read dir;
do

  name=$(echo "$dir" | sed -E "s/.*\///")

  if [[ ! -f "${SCRIPT_DIR}/${FLAVOR_DIR}/${name}/main.tf" ]]; then
    continue
  fi

  if [[ "${name}" =~ ^210 ]] && [[ "${name}" != "${STORAGE}" ]]; then
    continue
  fi

  echo "Setting up current/${name} from ${name}"

  mkdir -p "${name}"
  cp -R "${SCRIPT_DIR}/${FLAVOR_DIR}/${name}/"* "${name}"
  cp -f "${SCRIPT_DIR}/apply.sh" "${name}/apply.sh"
  cp -f "${SCRIPT_DIR}/destroy.sh" "${name}/destroy.sh"

  (cd "${name}" && ln -s ../bin bin2)
done

echo "Move to ${WORKSPACE_DIR} this is where your automation is configured"
