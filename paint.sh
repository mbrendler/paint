#! /bin/bash

set -euo pipefail

readonly DEFAULT_STTY="$(stty -g)"
export TTY;TTY="$(tty)"

function clean-stty() {
  stty "$DEFAULT_STTY"
}

trap clean-stty EXIT

stty raw -echo

./paint "$@"
