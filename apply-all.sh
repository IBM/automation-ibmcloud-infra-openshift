#!/usr/bin/env bash

terragrunt run-all apply --terragrunt-parallelism 1 --terragrunt-non-interactive --terragrunt-exclude-dir="${PWD}/.mocks/"*
