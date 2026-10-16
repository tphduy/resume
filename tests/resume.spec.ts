import { test, expect, type Page, type Locator } from '@playwright/test';
import AxeBuilder from '@axe-core/playwright';
import { readFile } from 'node:fs/promises';
import { resolve } from 'node:path';
import { createHash } from 'node:crypto';

const output = resolve(process.env.RESUME_OUT || 'site');
const sizes = [
  { name: 'mobile', viewport: { width: 320, height: 740 } },
  { name: 'desktop', viewport: { width: 1280, height: 900 } },
];
const downloads = [
  { name: 'Download PDF', file: 'resume.pdf' },
  { name: 'Download Markdown', file: 'resume.md' },
];

async function verifyDownload(page: Page, link: Locator, file: string, keyboard = false) {
  const pending = page.waitForEvent('download');
  if (keyboard) await page.keyboard.press('Enter');
  else await link.click();
  const download = await pending;
  expect(download.suggestedFilename()).toBe(file);
  expect(await download.failure()).toBeNull();
  const path = await download.path();
  expect(path).not.toBeNull();
  const digest = async (path: string) => createHash('sha256').update(await readFile(path)).digest('hex');
  expect(await digest(path!)).toBe(await digest(resolve(output, file)));
}

async function tabTo(page: Page, target: Locator) {
  // Bound traversal by the actual interactive content, not a hardcoded tab order.
  const limit = await page.locator('a[href], button, input, select, textarea, [tabindex]').count() + 2;
  for (let i = 0; i < limit; i++) {
    await page.keyboard.press('Tab');
    if (await target.evaluate(el => el === document.activeElement)) {
      await expect(target).toBeInViewport();
      return;
    }
  }
  throw new Error('Control is unreachable by keyboard');
}

for (const size of sizes) {
  test.describe(size.name, () => {
    test.use({ viewport: size.viewport, colorScheme: 'light' });

    for (const item of downloads) {
      test(`${item.name} saves the published file`, async ({ page }) => {
        await page.goto('/');
        await verifyDownload(page, page.getByRole('link', { name: item.name, exact: true }), item.file);
      });
    }

    test('contact links remain readable and keyboard accessible', async ({ page }, testInfo) => {
      await page.goto('/');
      const contacts = page.locator('.hero-contact a');
      const count = await contacts.count();
      expect(count).toBeGreaterThan(0);
      const boxes = [];
      for (let i = 0; i < count; i++) {
        const link = contacts.nth(i);
        await expect(link).toBeInViewport({ ratio: 1 });
        await tabTo(page, link);
        await expect(link).toBeFocused();
        const box = await link.boundingBox();
        expect(box).not.toBeNull();
        boxes.push(box!);
      }
      for (let i = 0; i < boxes.length; i++) {
        for (const b of boxes.slice(i + 1)) {
          const a = boxes[i];
          expect(a.x + a.width <= b.x || b.x + b.width <= a.x
            || a.y + a.height <= b.y || b.y + b.height <= a.y).toBe(true);
        }
      }
      await page.locator('.hero').screenshot({ path: testInfo.outputPath('contact-header.png') });
    });

    test('name keeps its text while structure marks stay decorative and fit', async ({ page }, testInfo) => {
      await page.goto('/');
      const heading = page.getByRole('heading', { level: 1, name: 'Tran Pham Hoang Duy', exact: true });
      await expect(heading).toHaveText('Tran Pham Hoang Duy');
      const parts = heading.locator('.name-part');
      await expect(parts).toHaveText(['Tran', 'Pham Hoang', 'Duy']);
      const labels = await parts.evaluateAll((els) => els.map((el) => getComputedStyle(el, '::before').content));
      expect(labels.map((content) => content.match(/Family|Middle|Given/)?.[0])).toEqual(['Family', 'Middle', 'Given']);
      expect(await page.evaluate(() => document.documentElement.scrollWidth <= window.innerWidth)).toBe(true);
      await page.locator('.hero').screenshot({ path: testInfo.outputPath('name-structure.png') });
    });

    test('keyboard can skip the header and activate both downloads', async ({ page }) => {
      await page.goto('/');
      const skip = page.getByRole('link', { name: 'Skip to resume' });
      await page.keyboard.press('Tab');
      await expect(skip).toBeFocused();
      await expect(skip).toBeInViewport();
      await page.keyboard.press('Enter');
      await expect(page.getByRole('main')).toBeFocused();

      for (const item of downloads) {
        await page.goto('/');
        const link = page.getByRole('link', { name: item.name, exact: true });
        await tabTo(page, link);
        await verifyDownload(page, link, item.file, true);
      }
    });

    for (const colorScheme of ['light', 'dark'] as const) {
      test(`readable and usable in ${colorScheme} mode`, async ({ page }) => {
        await page.emulateMedia({ colorScheme });
        await page.goto('/');
        await page.evaluate(() => document.fonts.ready);
        expect(await page.evaluate(() => document.documentElement.scrollWidth <= document.documentElement.clientWidth + 1)).toBe(true);
        const links = downloads.map(item => page.getByRole('link', { name: item.name, exact: true }));
        for (const link of links) {
          await link.scrollIntoViewIfNeeded();
          await expect(link).toBeInViewport({ ratio: 1 });
          await link.click({ trial: true });
        }
        // Measure both controls in the same scroll position.
        const [a, b] = await Promise.all(links.map(link => link.boundingBox()));
        expect(a).not.toBeNull();
        expect(b).not.toBeNull();
        expect(a!.x + a!.width <= b!.x || b!.x + b!.width <= a!.x || a!.y + a!.height <= b!.y || b!.y + b!.height <= a!.y).toBe(true);
        const result = await new AxeBuilder({ page }).withRules(['color-contrast']).analyze();
        expect(result.violations).toEqual([]);
      });
    }
  });
}

test('system appearance changes the rendered theme without reload', async ({ page }) => {
  await page.emulateMedia({ colorScheme: 'light' });
  await page.goto('/');
  const background = () => page.evaluate(() => getComputedStyle(document.documentElement).backgroundColor);
  const light = await background();
  await page.emulateMedia({ colorScheme: 'dark' });
  await expect.poll(background).not.toBe(light);
});
