# Resume

The public version of [my resume](https://tphduy.github.io/resume), as [PDF](https://tphduy.github.io/resume/resume.pdf) and [Markdown](resume.md). GitHub Actions builds both from `resume.md`.

## Build locally

```bash
brew install pandoc typst poppler   # poppler: `verify`
make site verify                    # writes site/
```

The website uses system sans-serif fonts and follows the visitor's light or dark appearance. Both download buttons save the original file: PDF for sharing and recruitment uploads, Markdown for agent-assisted reading and summarization.

Web presentation lives in `templates/web.html` and `styles/resume.css`. An HTML-only filter in `scripts/web.lua` places the existing name, role, and contacts in the page header. The shared `scripts/contacts.lua` filter groups contact details into two rows in both editions, marks Singapore and Vietnam phone numbers with flag emojis, and prints the profile address in the PDF. All contact values and resume wording stay in `resume.md`.

PDFs use Times with Pandoc/Typst defaults for page layout and a smaller, left-aligned contact block. Web styling does not affect the PDF.

Variable: `OUT` (default `site`).

## Browser checks

Install Node.js 24 and the build tools above:

```bash
npm ci
npx playwright install chromium
make e2e
```

`make e2e` builds, verifies, and tests downloads, keyboard access, responsive layouts, and light/dark contrast in Chromium. Tests check behavior rather than exact styling or resume wording. CI gates publishing on these checks and retains reports and failure evidence for seven days.

The managed test server uses port 8766; override with `E2E_PORT`. Custom output: `make e2e OUT=/absolute/path` (no spaces).

Debug: `npm run test:e2e:headed`. Report: `npx playwright show-report`. For custom output, set `RESUME_OUT` when running npm directly.
