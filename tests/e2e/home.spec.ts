import { test, expect } from '@playwright/test'

test.describe('Frontend UI Tests', () => {
  test('should display homepage', async ({ page }) => {
    await page.goto('/')
    
    // Check for welcome message
    await expect(page.locator('h1')).toContainText('Selamat Datang')
    
    // Check for navigation
    await expect(page.locator('text=Persons')).toBeVisible()
    await expect(page.locator('text=Family Tree')).toBeVisible()
    await expect(page.locator('text=Partuturan')).toBeVisible()
  })

  test('should navigate to persons page', async ({ page }) => {
    await page.goto('/')
    
    // Click on Persons link
    await page.click('text=Persons')
    
    // Should be on persons page
    await expect(page).toHaveURL('/persons')
    await expect(page.locator('h1')).toContainText('Daftar Person')
  })

  test('should navigate to family tree page', async ({ page }) => {
    await page.goto('/')
    
    // Click on Family Tree link
    await page.click('text=Family Tree')
    
    // Should be on tree page
    await expect(page).toHaveURL('/tree')
    await expect(page.locator('h1')).toContainText('Family Tree')
  })

  test('should navigate to partuturan page', async ({ page }) => {
    await page.goto('/')
    
    // Click on Partuturan link
    await page.click('text=Partuturan')
    
    // Should be on partuturan page
    await expect(page).toHaveURL('/partuturan')
    await expect(page.locator('h1')).toContainText('Partuturan')
  })
})
