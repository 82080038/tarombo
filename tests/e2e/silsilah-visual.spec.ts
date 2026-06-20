import { test, expect } from '@playwright/test';

test('silsilah page - visual check', async ({ page }) => {
    await page.goto('http://localhost/tarombo/silsilah');
    await page.waitForLoadState('networkidle');

    // Check title
    await expect(page.locator('h2')).toContainText('Pohon Silsilah Batak');

    // Check marga list is rendered
    const margaCards = page.locator('.card .card-body');
    await expect(margaCards.first()).toBeVisible();

    // Take full page screenshot
    await page.screenshot({ path: 'test-results/silsilah-tree.png', fullPage: true });
    console.log('Screenshot saved to test-results/silsilah-tree.png');

    // Check page has content
    const bodyText = await page.locator('body').textContent();
    expect(bodyText).toContain('marga');
});

test('silsilah detail tokoh - shows istri and ibu', async ({ page }) => {
    await page.goto('http://localhost/tarombo/silsilah');
    await page.waitForLoadState('networkidle');

    // Search for Si Lahi Sabungan
    await page.fill('#tokohSearch', 'Si Lahi Sabungan');
    await page.waitForTimeout(500);

    // Click on the first visible tokoh card
    const tokohCard = page.locator('.tokoh-item:visible').first();
    await tokohCard.click();
    await page.waitForTimeout(500);

    // Check detail panel appears
    const detailPanel = page.locator('#tokohDetailContent');
    await expect(detailPanel).toBeVisible();

    // Check istri section has content (Si Boru Pareme)
    const detailText = await detailPanel.textContent();
    expect(detailText).toContain('Si Boru Pareme');

    // Check ibu section has content (Putri Sariburaja)
    expect(detailText).toContain('Putri Sariburaja');

    // Check ayah section (Tuan Sorbadibanua)
    expect(detailText).toContain('Tuan Sorbadibanua');

    // Check keturunan section has children
    expect(detailText).toContain('Sihaloho');

    console.log('Detail tokoh test passed - istri, ibu, ayah, children all visible');
});

test('silsilah detail tokoh - female node shows suami', async ({ page }) => {
    await page.goto('http://localhost/tarombo/silsilah');
    await page.waitForLoadState('networkidle');

    // Search for Si Boru Pareme (female, istri of Si Lahi Sabungan)
    await page.fill('#tokohSearch', 'Si Boru Pareme');
    await page.waitForTimeout(500);

    // Click on the first visible tokoh card
    const tokohCard = page.locator('.tokoh-item:visible').first();
    await tokohCard.click();
    await page.waitForTimeout(500);

    // Check detail panel appears
    const detailPanel = page.locator('#tokohDetailContent');
    await expect(detailPanel).toBeVisible();

    // Check suami section shows Si Lahi Sabungan
    const detailText = await detailPanel.textContent();
    expect(detailText).toContain('Suami');
    expect(detailText).toContain('Si Lahi Sabungan');

    console.log('Female node test passed - suami visible');
});
