#!/bin/bash

set -o nounset
set -o pipefail

GIT_HEAD_REVISION=$(git rev-parse HEAD)
TEXT_BOLD=$(tput bold)
TEXT_COLORIZED=$(tput setaf 6) # Cyan
TEXT_RESET=$(tput sgr0)

function log_basic_settings {
  log_hardware_details
  log_env_variables
  log_setting "Git HEAD revision" "${GIT_HEAD_REVISION}"
}

function log_hardware_details {
  log_setting "Hardware details"

  inxi -Fxz 2> /dev/null
}

function log_env_variables {
  log_setting "Environment variables"

  env_variable_keys=$(env | cut -z -f1)

  for env_var in $env_variable_keys; do
    echo ">    ${env_var}"
  done
}

function log_setting {
  label=$1
  setting=${2:-""}

  echo "> ${TEXT_BOLD}${label}:${TEXT_RESET} ${setting}"
}
