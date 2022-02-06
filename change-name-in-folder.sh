#!/bin/bash
folder=$1

if [ -z "${folder}" ]; then
  exit 1
fi

declare -a waiting=("${folder}")

while [ "${#waiting[@]}" -gt 0 ]; do
  work=${waiting[0]}

  # rename all files and folders
  child="$(find "${work}" -mindepth 1 -maxdepth 1 -not -path '*/.*')"
  readarray -t childArray <<<"$child"
  for child in "${childArray[@]}"; do
    if [[ "${child}" =~ (.* .+) ]]; then
      newPaths=${child//' '/'_'}
      mv "${child}" "${newPaths}"
    fi
  done

  # update the waiting folders
  childDir="$(find "${work}" -mindepth 1 -maxdepth 1 -type d -not -path '*/.*')"
  readarray -t childDirArray <<<"$childDir"
  waiting=("${waiting[@]:1}")
  for childDir in "${childDirArray[@]}"; do
    if [ -n "${childDir}" ]; then
      waiting+=("${childDir}")
    fi
  done
done
