import { test, expect } from '@playwright/test'

test.describe('Frontend UI Tests - HTML/jQuery', () => {
  test('should display homepage', async ({ page }) => {
    await page.goto('index.html')

    // Check for welcome message
    await expect(page.locator('h1')).toContainText('Horas! Selamat Datang')

    // Check for navigation links (use more specific selector)
    await expect(page.locator('.navbar-nav a[href="persons.html"]')).toBeVisible()
    await expect(page.locator('.navbar-nav a[href="family-tree.html"]')).toBeVisible()
    await expect(page.locator('.navbar-nav a[href="partuturan.html"]')).toBeVisible()
  })

  test('should navigate to persons page', async ({ page }) => {
    await page.goto('index.html')

    // Click on Persons link in navigation
    await page.click('.navbar-nav a[href="persons.html"]')

    // Should be on persons page
    await expect(page).toHaveURL(/persons\.html/)
    await expect(page.locator('h1')).toContainText('Daftar Dongan Tubu')
  })

  test('should navigate to family tree page', async ({ page }) => {
    await page.goto('index.html')

    // Click on Family Tree link in navigation
    await page.click('.navbar-nav a[href="family-tree.html"]')

    // Should be on tree page
    await expect(page).toHaveURL(/family-tree\.html/)
    await expect(page.locator('h1')).toContainText('Pohon Tarombo')
  })

  test('should navigate to partuturan page', async ({ page }) => {
    await page.goto('index.html')

    // Click on Partuturan link in navigation
    await page.click('.navbar-nav a[href="partuturan.html"]')

    // Should be on partuturan page
    await expect(page).toHaveURL(/partuturan\.html/)
    await expect(page.locator('h1')).toContainText('Kalkulator Partuturan')
  })
})
