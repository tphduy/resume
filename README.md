# Resume

The public version of [my resume](https://tphduy.github.io/resume), as
[PDF](https://tphduy.github.io/resume/resume.pdf) and [Markdown](resume.md).
GitHub Actions builds both from `resume.md`.

## Build locally

    brew install pandoc typst poppler   # poppler: `verify`
    make site verify                    # writes site/

Needs SF Pro Text ([download](https://developer.apple.com/fonts/)), or
`make fonts FONT_PATH=fonts` and pass the same `FONT_PATH` to `make`.
Variables: `OUT` (default `site`), `FONT_PATH`.
