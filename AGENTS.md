# Public resume maintenance

## Setup

Install Node.js 24, Python 3, and the build tools, then install browser-test dependencies:

```bash
brew install pandoc typst poppler
npm ci
npx playwright install chromium
```

## Build, test, and preview

After resume, metadata, template, style, build, or test changes:

1. Run `make e2e` to build into `site/`, verify artifacts, and run Chromium tests.
2. Serve the output with `python3 -m http.server 8000 --bind 127.0.0.1 --directory site`. Reuse an existing server for this directory, or use the next free port if 8000 is occupied.
3. Leave the preview available and report its localhost URL. Report verification or preview failures explicitly.

Use browser tests for downloads, keyboard access, and rendered usability; keep file generation and content checks at the build or unit level. Assert behavior rather than exact spacing or fixed resume wording.

## Custom output and debugging

- Use `make e2e OUT=/absolute/path` for custom output; the path must contain no spaces. Serve that directory for preview.
- The managed test server uses port 8766; override with `E2E_PORT`.
- Run headed tests with `npm run test:e2e:headed`; view the report with `npx playwright show-report`.
- Set `RESUME_OUT` to the output directory when running npm tests directly with custom output.
