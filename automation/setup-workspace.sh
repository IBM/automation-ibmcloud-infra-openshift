#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname $0); pwd -P)

WORKSPACES_DIR="${SCRIPT_DIR}/../workspaces"

WORKSPACE_DIR="${WORKSPACES_DIR}/current"

if [[ -d "${WORKSPACE_DIR}" ]]; then
  DATE=$(date "+%Y%m%d%H%M")
  mv "${WORKSPACE_DIR}" "${WORKSPACES_DIR}/workspace-${DATE}"
fi

mkdir -p "${WORKSPACE_DIR}"

FLAVORS=($(find "${SCRIPT_DIR}" -type d -maxdepth 1 | grep "${SCRIPT_DIR}/" | sed -E "s~${SCRIPT_DIR}/~~g" | sort | sed -e "s/[0-9]-//g"))

PS3="Select the flavor: "

select flavor in ${FLAVORS[@]}; do
  if [[ -n "$flavor" ]]; then
    break
  fi
done

FLAVOR_DIR="${REPLY}-${flavor}"

WORKSPACE_DIR=$(cd "${WORKSPACE_DIR}"; pwd -P)

echo "Setting up automation for ${flavor} in ${WORKSPACE_DIR}"
cp -R "${SCRIPT_DIR}/${FLAVOR_DIR}/"* "${WORKSPACE_DIR}"
cp -R "${SCRIPT_DIR}/${FLAVOR_DIR}/terraform.tfvars-template" "${WORKSPACE_DIR}/terraform.tfvars"

TFVARS="${WORKSPACE_DIR}/terraform.tfvars"
find "${WORKSPACE_DIR}" -name main.tf | while read file; do
  terraform_dir=$(dirname "${file}")

  ln -s "${TFVARS}" "${terraform_dir}"
done
