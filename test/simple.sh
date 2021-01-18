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
  pack build -b $BP_DIR tf-cnb-test-simple-root --pull-policy if-not-present

  actual=$(docker run --name tf-cnb-test -it tf-cnb-test-simple-root terraform version)

  echo "$actual" | grep "0.14.4"

  docker rm tf-cnb-test
  docker rmi -f tf-cnb-test-simple-root
  rm -rf $test_dir

  return 0
}

_test_simple_nested() {
  test_dir=$(mktemp -d)
  cd $test_dir
  mkdir -p $test_dir/tf/modules
  cat <<EOF > $test_dir/tf/modules/main.tf
variable "token" {}
EOF
  pack build -b $BP_DIR tf-cnb-test-simple-root --pull-policy if-not-present

  actual=$(docker run --name tf-cnb-test -it tf-cnb-test-simple-root terraform version)

  echo "$actual" | grep "0.14.4"

  docker rm tf-cnb-test
  docker rmi -f tf-cnb-test-simple-root
  rm -rf $test_dir

  return 0
}

_test_simple_root && echo "PASS: _test_simple_root"
_test_simple_nested && echo "PASS: _test_simple_nested"
