#!/bin/sh

if [ -z "${2}" ]; then
  echo "Usage: ${0} profile message"
  exit 1
fi

aws --profile ${1} sts decode-authorization-message --encoded-message ${2} |jq .DecodedMessage -r|jq
