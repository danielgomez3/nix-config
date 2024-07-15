# # NOTE: With Arguments:
# pandoc --pdf-engine=xelatex --number-sections --toc "$1" -V geometry:a4paper -V geometry:margin=2cm -o "$2" -H chapter_breaks.tex --include-before-body cover.tex --toc-depth=4

pandoc actvsamsung-review.md \
  -M link-citations=true \
  --citeproc \
  --bibliography references.bib \
  --pdf-engine=xelatex \
  --number-sections \
  --toc actvsamsung-review.md \
  -V geometry:a4paper \
  -V geometry:margin=2cm \
  -H chapter_breaks.tex \
  --include-before-body cover.tex --toc-depth=4 \
  -o actvsamsung-review.pdf \
