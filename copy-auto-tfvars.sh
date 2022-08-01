#!/usr/bin/env bash

FROM="${1}"
TO="${2}"

find "${FROM}" -maxdepth 1 -name "*.auto.tfvars.json" -exec cp {} "${TO}" \;
find "${FROM}" -maxdepth 1 -name "*.auto.tfvars" -exec cp {} "${TO}" \;
