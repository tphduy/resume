import { defineConfig } from '@playwright/test';
import { resolve } from 'node:path';

const output = resolve(process.env.RESUME_OUT || 'site');
const port = Number(process.env.E2E_PORT || 8766);
const baseURL = `http://127.0.0.1:${port}`;

export default defineConfig({
  testDir: './tests',
  workers: 1,
  retries: 0,
  timeout: 30_000,
  reporter: [['list'], ['html', { open: 'never' }]],
  use: {
    baseURL,
    browserName: 'chromium',
    trace: 'retain-on-failure',
    screenshot: 'only-on-failure',
  },
  webServer: {
    command: `python3 -u -m http.server ${port} --bind 127.0.0.1 --directory "${output.replace(/[$`"\\]/g, '\\$&')}"`,
    url: baseURL,
    reuseExistingServer: false,
    stdout: 'pipe',
    timeout: 60_000,
  },
});
