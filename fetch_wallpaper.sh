#!/usr/bin/env bash
set -euo pipefail

REPO_OWNER="${REPO_OWNER:-babyanonymouse}"
REPO_NAME="${REPO_NAME:-walls}"
BRANCH="${BRANCH:-main}"
WALLPAPER_DIR="${WALLPAPER_DIR:-$HOME/Ricelin/wallpapers}"
SETTER="${SETTER:-$HOME/.config/hypr/scripts/wallpaper.sh}"
CACHE_ROOT="${XDG_CACHE_HOME:-$HOME/.cache}/ricelin-wallpaper-src"

case "${1:-}" in
    fetch|random|set)
        ;;
    "")
        ;;
    *)
        echo "Usage: $0 [fetch|random|set]"
        exit 1
        ;;
esac

repo_root="$WALLPAPER_DIR/github/$REPO_OWNER/$REPO_NAME"
repo_url="https://github.com/${REPO_OWNER}/${REPO_NAME}.git"
src_root="$CACHE_ROOT/${REPO_OWNER}/${REPO_NAME}"

mkdir -p "$repo_root" "$CACHE_ROOT/${REPO_OWNER}"

if [ -d "$src_root/.git" ]; then
    git -C "$src_root" fetch --depth 1 origin "$BRANCH"
    git -C "$src_root" checkout -f "$BRANCH" >/dev/null 2>&1 || true
    git -C "$src_root" reset --hard "origin/$BRANCH" >/dev/null
else
    git clone --depth 1 --branch "$BRANCH" --single-branch "$repo_url" "$src_root" >/dev/null
fi

file_list=$(cd "$src_root" && find . -path './.git' -prune -o -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' -o -iname '*.gif' -o -iname '*.mp4' -o -iname '*.webm' -o -iname '*.mkv' -o -iname '*.mov' \) -print | sed 's|^./||' | sort)

if [ -z "$file_list" ]; then
    echo "Error: no supported wallpapers found in ${REPO_OWNER}/${REPO_NAME}:${BRANCH}."
    exit 1
fi

random_file=$(printf '%s\n' "$file_list" | shuf -n 1)

source_path="$src_root/$random_file"
target_path="$repo_root/$random_file"
mkdir -p "$(dirname "$target_path")"

tmp_path="$target_path.tmp"
echo "Fetching: $random_file"
cp "$source_path" "$tmp_path"
mv "$tmp_path" "$target_path"

if [ -x "$SETTER" ]; then
    "$SETTER" set "$target_path" all
else
    echo "Warning: wallpaper setter not found at $SETTER"
fi

echo "$target_path"
