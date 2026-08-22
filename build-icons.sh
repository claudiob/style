#!/bin/sh
# Renders the whole icon set from icon.svg.
#
# Needs rsvg-convert and magick:  brew install librsvg imagemagick
#
# Run it after editing icon.svg and commit what changes.
# Never touch a PNG by hand, or the set drifts apart one file at a time.

set -eu
cd "$(dirname "$0")"

command -v rsvg-convert >/dev/null || { echo 'rsvg-convert missing: brew install librsvg' >&2; exit 1; }
command -v magick       >/dev/null || { echo 'magick missing: brew install imagemagick' >&2; exit 1; }

# iOS masks a home-screen bookmark and every avatar is shown round, so those
# two render from the same drawing with its corners squared off. A corner
# rounded twice reads as a mistake. Derived here rather than kept as a second
# file, so there stays exactly one drawing to edit.
square=$(mktemp)
trap 'rm -f "$square"' EXIT
sed 's/ rx="16"//' icon.svg > "$square"

render() { rsvg-convert -w "$2" -h "$2" "$1" -o "$3"; }

# what a browser reaches for when the page links nothing
render icon.svg 16 ico-16.png
render icon.svg 32 ico-32.png
render icon.svg 48 ico-48.png
magick ico-16.png ico-32.png ico-48.png favicon.ico
rm -f ico-16.png ico-32.png ico-48.png

render icon.svg    96 favicon-96x96.png              # the tab
render "$square"  180 apple-touch-icon.png           # a home-screen bookmark
render icon.svg   192 web-app-manifest-192x192.png   # named in site.webmanifest
render icon.svg   512 web-app-manifest-512x512.png   # the same
render "$square" 1024 avatar.png                     # GitHub and the social networks

echo 'icons rendered:'
ls -1 favicon.ico favicon-96x96.png apple-touch-icon.png \
      web-app-manifest-192x192.png web-app-manifest-512x512.png avatar.png
