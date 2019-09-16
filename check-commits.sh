#!/bin/bash

CHEKER_PATH=$1
ERR_COUNT=0

for i in $(git log --format='%h'); do
  git checkout $i &> /dev/null

  cat users.csv | $CHEKER_PATH
  if [ $? = 1 ]; then
    (( $ERR_COUNT++ ))
    COMMIT_MSG=$(git log --format='%s' -n 1 $i)
    LAST_COMMIT=$(git log HEAD^ --format='%h - %B' -1)
    echo "[NG] $i $COMMIT_MSG¥n"
    echo "Last commit:"
    echo ${LAST_COMMIT}
  fi

  git checkout master &> /dev/null
done

if [ $ERR_COUNT = 0 ]; then
  echo "All commits are clean 笨ｨ"
fi
