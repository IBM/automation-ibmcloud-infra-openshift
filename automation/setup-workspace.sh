#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname $0); pwd -P)

FLAVORS=($(find "${SCRIPT_DIR}" -type d -maxdepth 1 | grep "${SCRIPT_DIR}/" | sed -E "s~${SCRIPT_DIR}/~~g" | sort | sed -e "s/[0-9]-//g" | awk '{$1=toupper(substr($1,0,1))substr($1,2)}1'))

PS3="Select the flavor: "

select flavor in ${FLAVORS[@]}; do
  if [[ -n "$flavor" ]]; then
    break
  fi
done

WORKSPACES_DIR="${SCRIPT_DIR}/../workspaces"

WORKSPACE_DIR="${WORKSPACES_DIR}/current"

if [[ -d "${WORKSPACE_DIR}" ]]; then
  DATE=$(date "+%Y%m%d%H%M")
  mv "${WORKSPACE_DIR}" "${WORKSPACES_DIR}/workspace-${DATE}"
fi

mkdir -p "${WORKSPACE_DIR}"

FLAVOR_DIR="${REPLY}-${flavor,,}"

WORKSPACE_DIR=$(cd "${WORKSPACE_DIR}"; pwd -P)

STORAGE_OPTIONS=($(find "${SCRIPT_DIR}/${FLAVOR_DIR}" -type d -maxdepth 1 -name "210-*" | grep "${SCRIPT_DIR}/${FLAVOR_DIR}/" | sed -E "s~${SCRIPT_DIR}/${FLAVOR_DIR}/~~g" | sort))

PS3="Select the storage: "

select storage in ${STORAGE_OPTIONS[@]}; do
  if [[ -n "${storage}" ]]; then
    break
  fi
done

echo "Setting up automation for ${flavor} in ${WORKSPACE_DIR}"
cp -R "${SCRIPT_DIR}/${FLAVOR_DIR}/"* "${WORKSPACE_DIR}"
rm -rf "${WORKSPACE_DIR}/"210-*
cp -R "${SCRIPT_DIR}/${FLAVOR_DIR}/${storage}" "${WORKSPACE_DIR}"
cp -R "${SCRIPT_DIR}/${FLAVOR_DIR}/terraform.tfvars-template" "${WORKSPACE_DIR}/terraform.tfvars"

find "${WORKSPACE_DIR}" -name main.tf | while read file; do
  terraform_dir=$(dirname "${file}")

  delta_dir=$(echo "${terraform_dir}" | sed -E "s~${WORKSPACE_DIR}/~~" | sed -E "s~(.*)/?~\1/~g")

  tf_vars_dir=$(echo "${delta_dir}" | sed -E "s~[^/]+/~../~g")

  $(cd "${terraform_dir}" && ln -s "${tf_vars_dir}terraform.tfvars" .)
done
