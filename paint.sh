#! /bin/bash

set -euo pipefail

readonly DEFAULT_STTY="$(stty -g)"

export columns;columns="$(tput cols)"
export lines;lines="$(tput lines)"

function clean-stty() {
  stty "$DEFAULT_STTY"
}

trap clean-stty EXIT

stty raw -echo

./paint "$@"
