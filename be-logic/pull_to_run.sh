#!/bin/bash

set -e  # stop if error

echo "=== Loading environment ==="

if [ -f .env.run ]; then
  export $(grep -v '^#' .env.run | xargs)
else
  echo ".env.run not found!"
  exit 1
fi

# default values nếu không có trong .env.run
BRANCH=${BRANCH:-master}

echo "=== Pulling latest code from branch: $BRANCH ==="

GIT_SSH_COMMAND="ssh -i $SSH_KEY" git pull origin $BRANCH

echo "=== Running application ==="

chmod +x ./run.sh
./run.sh

echo "=== Done ==="
