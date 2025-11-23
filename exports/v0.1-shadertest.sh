#!/bin/sh
printf '\033c\033]0;%s\a' jogo de bosta
base_path="$(dirname "$(realpath "$0")")"
"$base_path/v0.1-shadertest.x86_64" "$@"
