#!/bin/sh

# set default text; take text from env var
OUTPUT_TEXT="${OUTPUT_TEXT:-hello world}"

echo "Writing ${OUTPUT_TEXT} to /var/www/index.html"
echo "${OUTPUT_TEXT}" > /var/www/index.html

echo "Executing ${*}"
exec "${@}"
