#!/usr/bin/env bash

# fail hard
set -o pipefail
# fail harder
set -eu

BP_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/.."

_test_simple_root() {
  test_dir=$(mktemp -d)
  cd $test_dir
  cat <<EOF > main.tf
variable "token" {}
EOF
  pack build --builder heroku/buildpacks:18 -b $BP_DIR tf-cnb-test-simple-root --pull-policy if-not-present

  actual=$(docker run --name tf-cnb-test tf-cnb-test-simple-root terraform version)

  docker rm tf-cnb-test
  docker rmi -f tf-cnb-test-simple-root
  rm -rf $test_dir

  if echo "$actual" | grep -vq "0.14.4"; then
    return 1
  fi

  return 0
}

_test_simple_nested() {
  test_dir=$(mktemp -d)
  cd $test_dir
  mkdir -p $test_dir/tf/modules
  cat <<EOF > $test_dir/tf/modules/main.tf
variable "token" {}
EOF
  pack build --builder heroku/buildpacks:18 -b $BP_DIR tf-cnb-test-simple-nested --pull-policy if-not-present

  actual=$(docker run --name tf-cnb-test tf-cnb-test-simple-nested terraform version)

  docker rm tf-cnb-test
  docker rmi -f tf-cnb-test-simple-nested
  rm -rf $test_dir

  if echo "$actual" | grep -vq "0.14.4"; then
    return 1
  fi

  return 0
}

_test_simple_heroku_20() {
  test_dir=$(mktemp -d)
  cd $test_dir
  cat <<EOF > main.tf
variable "token" {}
EOF
  pack build --builder heroku/buildpacks:20 -b $BP_DIR tf-cnb-test-simple-heroku-20 --pull-policy if-not-present

  actual=$(docker run --name tf-cnb-test -it tf-cnb-test-simple-heroku-20 terraform version)

  docker rm tf-cnb-test
  docker rmi -f tf-cnb-test-simple-heroku-20
  rm -rf $test_dir

  if echo "$actual" | grep -vq "0.14.4"; then
    return 1
  fi

  return 0
}

_test_simple_root && echo "PASS: _test_simple_root" || exit 1
_test_simple_nested && echo "PASS: _test_simple_nested" || exit 1
_test_simple_heroku_20 && echo "PASS: _test_simple_nested" || exit 1
