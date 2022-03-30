#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname $0); pwd -P)

WORKSPACES_DIR="${SCRIPT_DIR}/../workspaces"

WORKSPACE_DIR="${WORKSPACES_DIR}/current"

if [[ -d "${WORKSPACE_DIR}" ]]; then
  DATE=$(date "+%Y%m%d%H%M")
  mv "${WORKSPACE_DIR}" "${WORKSPACES_DIR}/workspace-${DATE}"
fi

mkdir -p "${WORKSPACE_DIR}"

WORKSPACE_DIR=$(cd "${WORKSPACE_DIR}"; pwd -P)

echo "Setting up automation in ${WORKSPACE_DIR}"
cp -R "${SCRIPT_DIR}/"* "${WORKSPACE_DIR}"
