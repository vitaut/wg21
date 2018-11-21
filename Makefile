%.pdf: %.pandoc
	pandoc template/header.yaml $< \
       --filter pandoc-citeproc \
       --filter template/diff.py \
       --filter template/tonytable.py \
       --highlight-style kate \
       --syntax-definition template/cpp.xml \
       --syntax-definition template/diff.xml \
       --template template/wg21.latex \
       --output pdf/$@

%.md: %.pandoc
	pandoc template/header.yaml $< \
       --filter pandoc-citeproc \
       --filter template/diff.py \
       --filter template/tonytable.py \
       --webtex \
       --to gfm \
       --output github/$@

SRC = boolean_explicit.pandoc \
      remove-cvref.pandoc

ALL_IN_ONE.pdf:
	pandoc template/header.yaml  \
       $(SRC) \
       --filter pandoc-citeproc \
       --filter template/diff.py \
       --filter template/tonytable.py \
       --highlight-style kate \
       --syntax-definition template/cpp.xml \
       --syntax-definition template/diff.xml \
       --template template/wg21.latex \
       --output pdf/$@

ALL_IN_ONE.md:
	pandoc template/header.yaml \
       $(SRC) \
       --filter pandoc-citeproc \
       --filter template/diff.py \
       --filter template/tonytable.py \
       --webtex \
       --to gfm \
       --output github/$@
