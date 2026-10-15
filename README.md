# Resume

The public version of [my resume](https://tphduy.github.io/resume), as
[PDF](https://tphduy.github.io/resume/resume.pdf) and [Markdown](resume.md).
GitHub Actions builds both from `resume.md`.

## Build locally

```bash
brew install pandoc typst poppler   # poppler: `verify`
make site verify                    # writes site/
```

The website uses the browser's default font. PDFs use Times to match Safari's
default serif appearance, with Pandoc/Typst defaults for page layout.

Variable: `OUT` (default `site`).
