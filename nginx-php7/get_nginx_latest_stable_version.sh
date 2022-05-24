#!/bin/bash

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
  fi
done

# latest stable version
echo "${STABLE_VERSIONS[0]}"
