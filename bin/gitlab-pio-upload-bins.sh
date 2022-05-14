#!/usr/bin/env bash

set -e

echo "INFO: Starting"

if [[ -z "${VERSION}" ]]; then
  echo "ERROR: VERSION string not set!!! we got '${VERSION}'"
  exit 1
fi

if [[ -z "${CI_PROJECT_ID}" ]]; then
  echo "ERROR: CI_PROJECT_ID not set!!! we got '${CI_PROJECT_ID}'"
  exit 1
fi

if [[ -z "${CI_API_V4_URL}" ]]; then
  echo "ERROR: CI_API_V4_URL not set!!! we got '${CI_API_V4_URL}'"
  exit 1
fi

if [[ -z "${CI_PROJECT_NAME}" ]]; then
  echo "ERROR: CI_PROJECT_NAME not set!!! we got '${CI_PROJECT_NAME}'"
  exit 1
fi

if [[ -z "${CI_JOB_TOKEN}" ]]; then
  echo "ERROR: CI_JOB_TOKEN not set!!!"
  exit 1
fi

echo "INFO: Using VERSION='${VERSION}' CI_PROJECT_NAME='${CI_PROJECT_NAME}' CI_PROJECT_ID='${CI_PROJECT_ID}'"
echo "INFO: CI_API_V4_URL='${CI_API_V4_URL}"

# shellcheck disable=SC2002
ENVIRONMENTS=$(cat platformio.ini | grep "\[env:" | cut -c6- | rev | cut -c2- | rev)
# shellcheck disable=SC2043
for ENVIRONMENT in ${ENVIRONMENTS}; do
  echo "INFO: Uploading '${ENVIRONMENT}'"

  # === BIN FILE ===
  BIN_FILE=".pio/build/${ENVIRONMENT}/firmware.bin"
  if [[ -f "${BIN_FILE}" ]]; then
    echo "INFO: Uploading '${BIN_FILE}'"
    curl \
      --header "JOB-TOKEN: ${CI_JOB_TOKEN}" \
      --upload-file ".pio/build/${ENVIRONMENT}/firmware.bin" \
      "${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/packages/generic/${CI_PROJECT_NAME}/${VERSION}/firmware-${ENVIRONMENT}-${VERSION}.bin"
  else
    echo "WARNING: '${ENVIRONMENT}' bin file not found '${BIN_FILE}'"
  fi

  # === ELF FILE ===
  #  ELF_FILE=".pio/build/${ENVIRONMENT}/firmware.elf"
  #  if [[ -f "${ELF_FILE}" ]]; then
  #    echo "INFO: Uploading '${ELF_FILE}'"
  #    curl \
  #      --header "JOB-TOKEN: ${CI_JOB_TOKEN}" \
  #      --upload-file "${ELF_FILE}" \
  #      "${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/packages/generic/${CI_PROJECT_NAME}/${VERSION}/firmware-esp32_dev-${VERSION}.elf"
  #  else
  #      echo "WARNING: '${ENVIRONMENT}' elf file not found '${ELF_FILE}'"
  #  fi
  echo "INFO: Uploaded '${ENVIRONMENT}'"
done

echo "INFO: Finished"
