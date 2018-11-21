# cpp20_in_TTs

A preview of what [cpp20_in_TTs] would look like under this framework.

[cpp20_in_TTs]: https://github.com/tvaneerd/cpp20_in_TTs

## Formatting

Refer to [How I format my C++ papers][FMT] for an overview.

[FMT]: https://mpark.github.io/programming/2018/11/16/how-i-format-my-cpp-papers

## Generation

```bash
make <feature>.md   // Generates `github/<feature>.md` from `<feature>.pandoc`
make <feature>.pdf  // Generates `pdf/<feature>.pdf` from `<feature>.pandoc`

make ALL_IN_ONE.md   // Generates `github/ALL_IN_ONE.md`
make ALL_IN_ONE.pdf  // Generates `pdf/ALL_IN_ONE.pdf`
```

## Requirements

  - `pdflatex`
  - `pandoc`
  - `pandoc-citeproc`
  - `python3`
  - `panflute`

### OS X

```bash
brew cask install mactex

brew install pandoc
brew install pandoc-citeproc

brew install python
pip3 install panflute
```
