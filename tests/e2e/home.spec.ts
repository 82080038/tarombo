import { test, expect } from '@playwright/test'

test.describe('Frontend UI Tests - Homepage & Navigation', () => {
  test('should display homepage', async ({ page }) => {
    await page.goto('')

    await expect(page.locator('h1')).toContainText('Horas! Selamat Datang')

    await expect(page.locator('.navbar-nav a[href="persons"]')).toBeVisible()
    await expect(page.locator('.navbar-nav a[href="family-tree"]')).toBeVisible()
    await expect(page.locator('.navbar-nav a[href="partuturan"]')).toBeVisible()
  })

  test('should navigate to persons page', async ({ page }) => {
    await page.goto('')

    await page.click('.navbar-nav a[href="persons"]')

    await expect(page).toHaveURL(/persons/)
    await expect(page.locator('h1')).toContainText('Dongan Tubu')
  })

  test('should navigate to family tree page', async ({ page }) => {
    await page.goto('')

    await page.click('.navbar-nav a[href="family-tree"]')

    await expect(page).toHaveURL(/family-tree/)
    await expect(page.locator('h1')).toContainText('Tarombo')
  })

  test('should navigate to partuturan page', async ({ page }) => {
    await page.goto('')

    await page.click('.navbar-nav a[href="partuturan"]')

    await expect(page).toHaveURL(/partuturan/)
    await expect(page.locator('h1')).toContainText('Partuturan')
  })

  test('should display login page', async ({ page }) => {
    await page.goto('login')

    await expect(page.locator('h1, h2, .card-title')).toContainText(/Login|Masuk/i)
  })

  test('should have working API health check', async ({ request }) => {
    const response = await request.get('http://localhost:8000/health')
    expect(response.ok()).toBeTruthy()
    const body = await response.json()
    expect(body.status).toBe('ok')
  })

  test('should load persons from API', async ({ request }) => {
    const response = await request.get('http://localhost:8000/api/v1/persons')
    expect(response.ok()).toBeTruthy()
    const body = await response.json()
    expect(body.success).toBe(true)
    expect(body.data).toBeDefined()
  })

  test('should load marga from API', async ({ request }) => {
    const response = await request.get('http://localhost:8000/api/v1/marga')
    expect(response.ok()).toBeTruthy()
    const body = await response.json()
    expect(body.success).toBe(true)
    expect(body.data).toBeDefined()
  })

  test('should calculate partuturan', async ({ request }) => {
    const personsRes = await request.get('http://localhost:8000/api/v1/persons')
    const personsBody = await personsRes.json()
    if (personsBody.data && personsBody.data.length >= 2) {
      const fromId = personsBody.data[0].id
      const toId = personsBody.data[1].id
      const response = await request.get(`http://localhost:8000/api/v1/partuturan/calculate?from=${fromId}&to=${toId}`)
      expect(response.ok()).toBeTruthy()
      const body = await response.json()
      expect(body.success).toBe(true)
    }
  })
})
