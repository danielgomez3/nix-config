#!/run/current-system/sw/bin/bash

# NOTE: optional argument
output_file=${2:-out.pdf}
PDF_VIEWER=${PDF_VIEWER:-zathura}


watch_and_compile() {
  echo "$1" | entr -pn \
  pandoc "$1" \
    --pdf-engine=xelatex \
    --number-sections \
    --toc=true \
    --toc-depth=3 \
    --highlight-style=tango \
    --metadata-file=deps/metadata.yaml \
    -H deps/formatting.tex \
    -o "$output_file" \
    "$1" \
    >/dev/null 2>&1
}

edit() {
  $EDITOR "$1" &
  $PDF_VIEWER "$output_file" &
}

edit "$1"
watch_and_compile "$1"
