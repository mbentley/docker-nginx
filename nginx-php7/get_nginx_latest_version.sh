#!/bin/bash

# which nginx branch to use (mainline or stable)
NGINX_BRANCH="${NGINX_BRANCH:-stable}"

# get nginx releases
NGINX_VERSIONS="$(curl -s https://api.github.com/repos/nginx/nginx/tags | jq -r '.[]|.name' | awk -F '-' '{print $2}')"

# check to see if each minor version is even or odd
for VERSION in ${NGINX_VERSIONS}
do
  MINOR_VERSION="$(echo "${VERSION}" | awk -F '.' '{print $2}')"

  # check if number passed as 1st option is odd or even
  if [ $(( MINOR_VERSION & 1 )) = "0" ]
  then
    # this minor version is even (stable)
    STABLE_VERSIONS=( "${STABLE_VERSIONS[@]}" "${VERSION}" )
  else
    # this minor version is odd (mainline)
    MAINLINE_VERSIONS=( "${MAINLINE_VERSIONS[@]}" "${VERSION}" )
  fi
done

if [ "${NGINX_BRANCH}" = "stable" ]
then
  # latest stable version
  echo "${STABLE_VERSIONS[0]}"
elif [ "${NGINX_BRANCH}" = "mainline" ]
then
  # latest mainline version
  echo "${MAINLINE_VERSIONS[0]}"
else
  # invalid version
  echo "ERROR: invalid branch!"
  exit 1
fi
