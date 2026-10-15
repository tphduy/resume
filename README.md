# Resume

The public version of [my resume](https://tphduy.github.io/resume), as [PDF](https://tphduy.github.io/resume/resume.pdf) and [Markdown](resume.md). GitHub Actions builds both from `resume.md`.

## Build locally

```bash
brew install pandoc typst poppler   # poppler: `verify`
make site verify                    # writes site/
```

The website uses system sans-serif fonts and follows the visitor's light or dark appearance. Both download buttons save the original file: PDF for sharing and recruitment uploads, Markdown for agent-assisted reading and summarization.

Web presentation lives in `templates/web.html` and `styles/resume.css`. An HTML-only filter in `scripts/web.lua` places the existing name, role, and contacts in the page header. Resume wording stays in `resume.md`.

PDFs use Times with Pandoc/Typst defaults for page layout. Web styling does not affect the PDF.

Variable: `OUT` (default `site`).
