import { test, expect } from '@playwright/test'

test('dashboard as guest - visual check', async ({ page }) => {
  await page.goto('http://localhost/tarombo/dashboard')
  await page.waitForLoadState('networkidle')
  await page.screenshot({ path: 'screenshots/dashboard-guest.png', fullPage: true })

  // Check that login prompt overlay is NOT present
  const overlay = page.locator('#authPromptOverlay')
  await expect(overlay).toHaveCount(0)

  // Check welcome text for guest
  const welcome = page.locator('.dashboard-welcome h2')
  await expect(welcome).toContainText('Selamat Datang di Tarombo Digital')

  // Check that stats section is NOT visible (guest)
  const stats = page.locator('#dashStats')
  await expect(stats).toHaveCount(0)

  // Check that activity table is NOT visible (guest)
  const activity = page.locator('#dashActivityTable')
  await expect(activity).toHaveCount(0)

  // Check feature showcase is visible
  const features = page.locator('.feature-card')
  const featureCount = await features.count()
  console.log(`Feature cards visible: ${featureCount}`)

  // Check CTA for guest has login/register buttons
  const ctaLoginBtn = page.locator('.card.bg-primary a:has-text("Masuk")')
  await expect(ctaLoginBtn).toBeVisible()

  const registerBtn = page.locator('a:has-text("Daftar")')
  await expect(registerBtn).toBeVisible()
})
