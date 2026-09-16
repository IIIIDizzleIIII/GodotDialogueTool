#!/bin/sh
printf '\033c\033]0;%s\a' VisualNovelDemo
base_path="$(dirname "$(realpath "$0")")"
"$base_path/VisualNovelDemo.x86_64" "$@"
