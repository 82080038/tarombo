import { test, expect } from '@playwright/test'

test.describe('API Backend Tests', () => {
  test('API health check responds correctly', async ({ request }) => {
    const response = await request.get('http://localhost:8000/health')
    expect(response.status()).toBe(200)
    const body = await response.json()
    expect(body.status).toBe('ok')
    expect(body.message).toBe('Tarombo Digital API')
  })

  test('GET /api/v1/persons returns list with meta', async ({ request }) => {
    const response = await request.get('http://localhost:8000/api/v1/persons')
    expect(response.status()).toBe(200)
    const body = await response.json()
    expect(body).toHaveProperty('data')
    expect(body).toHaveProperty('meta')
    expect(Array.isArray(body.data)).toBeTruthy()
    expect(body.meta.total).toBeGreaterThan(0)
  })

  test('GET /api/v1/marga returns clan list', async ({ request }) => {
    const response = await request.get('http://localhost:8000/api/v1/marga')
    expect(response.status()).toBe(200)
    const body = await response.json()
    expect(body).toHaveProperty('data')
    expect(body.total).toBeGreaterThan(0)
  })

  test('GET /api/v1/persons/1 returns person detail with relationships', async ({ request }) => {
    const response = await request.get('http://localhost:8000/api/v1/persons/1')
    expect(response.status()).toBe(200)
    const body = await response.json()
    expect(body.data.id).toBe(1)
    expect(body.data.nama).toBe('John Simanjuntak')
    expect(body.data).toHaveProperty('father')
  })

  test('GET /api/v1/persons/9999 returns 404', async ({ request }) => {
    const response = await request.get('http://localhost:8000/api/v1/persons/9999')
    expect(response.status()).toBe(404)
    const body = await response.json()
    expect(body.error.code).toBe('PERSON_NOT_FOUND')
  })

  test('GET /api/v1/partuturan/calculate?from=8&to=1 returns relationship', async ({ request }) => {
    const response = await request.get('http://localhost:8000/api/v1/partuturan/calculate?from=8&to=1')
    expect(response.status()).toBe(200)
    const body = await response.json()
    expect(body.success).toBe(true)
    expect(body.data).toHaveProperty('from_person')
    expect(body.data).toHaveProperty('to_person')
    expect(body.data).toHaveProperty('relationship')
    expect(body.data).toHaveProperty('indonesian')
    expect(body.data).toHaveProperty('path')
    expect(body.data.from_person.id).toBe(8)
    expect(body.data.to_person.id).toBe(1)
  })

  test('GET /api/v1/partuturan/calculate missing params returns 400', async ({ request }) => {
    const response = await request.get('http://localhost:8000/api/v1/partuturan/calculate')
    expect(response.status()).toBe(400)
  })

  test('GET /api/v1/persons with search filter', async ({ request }) => {
    const response = await request.get('http://localhost:8000/api/v1/persons?search=John')
    expect(response.status()).toBe(200)
    const body = await response.json()
    expect(body.data.length).toBeGreaterThan(0)
    expect(body.data[0].nama).toContain('John')
  })

  test('POST /api/v1/persons without auth returns 401', async ({ request }) => {
    const response = await request.post('http://localhost:8000/api/v1/persons', {
      data: { nama: 'Test', marga_id: 1, jenis_kelamin: 'L' }
    })
    expect(response.status()).toBe(401)
  })
})

test.describe('Persons Page - Functional Tests', () => {
  test('persons page loads and displays table', async ({ page }) => {
    await page.goto('persons')
    await expect(page.locator('h1')).toContainText('Daftar Dongan Tubu')
    await expect(page.locator('#searchInput')).toBeVisible()
    await expect(page.locator('#personsTable')).toBeVisible()
    // Wait for data to load
    await page.waitForFunction(() => {
      const rows = document.querySelectorAll('#personsTable tr')
      return rows.length > 1 && !rows[0].textContent?.includes('Loading')
    }, { timeout: 5000 })
    const rows = await page.locator('#personsTable tr').count()
    expect(rows).toBeGreaterThan(1)
  })

  test('search filter works on persons page', async ({ page }) => {
    await page.goto('persons')
    await page.waitForFunction(() => {
      const rows = document.querySelectorAll('#personsTable tr')
      return rows.length > 1 && !rows[0].textContent?.includes('Loading')
    }, { timeout: 5000 })
    await page.fill('#searchInput', 'John')
    await page.waitForTimeout(300)
    const rows = await page.locator('#personsTable tr').count()
    expect(rows).toBeGreaterThanOrEqual(1)
    const firstRowText = await page.locator('#personsTable tr').first().textContent()
    expect(firstRowText).toContain('John')
  })

  test('tambah person modal opens and closes', async ({ page, request }) => {
    const loginRes = await request.post('http://localhost:8000/api/v1/auth/quick-login', { data: { role: 'admin' } })
    const loginBody = await loginRes.json()
    await page.goto('')
    await page.evaluate((token) => localStorage.setItem('tarombo_token', token), loginBody.data.access_token)
    await page.goto('persons')
    await page.waitForTimeout(1000)
    await page.click('button[data-bs-target="#addPersonModal"]')
    await expect(page.locator('#addPersonModal')).toBeVisible()
    await page.click('#addPersonModal .btn-close')
    await page.waitForTimeout(500)
    await expect(page.locator('#addPersonModal')).not.toBeVisible()
  })

  test('marga dropdown populated in add person modal', async ({ page, request }) => {
    const loginRes = await request.post('http://localhost:8000/api/v1/auth/quick-login', { data: { role: 'admin' } })
    const loginBody = await loginRes.json()
    await page.goto('')
    await page.evaluate((token) => localStorage.setItem('tarombo_token', token), loginBody.data.access_token)
    await page.goto('persons')
    await page.waitForTimeout(1000)
    await page.click('button[data-bs-target="#addPersonModal"]')
    await page.waitForFunction(() => {
      const select = document.querySelector('#margaSelect') as HTMLSelectElement
      return select && select.options.length > 1
    }, { timeout: 5000 })
    const optionCount = await page.locator('#margaSelect option').count()
    expect(optionCount).toBeGreaterThan(1)
  })
})

test.describe('Family Tree Page - Functional Tests', () => {
  test('family tree page loads correctly', async ({ page }) => {
    await page.goto('family-tree')
    await expect(page.locator('h1')).toContainText('Pohon Tarombo')
    await expect(page.locator('#rootPersonSelect')).toBeVisible()
  })

  test('person select populated in family tree', async ({ page }) => {
    await page.goto('family-tree')
    await page.waitForFunction(() => {
      const select = document.querySelector('#rootPersonSelect') as HTMLSelectElement
      return select && select.options.length > 1
    }, { timeout: 60000 })
    const optionCount = await page.locator('#rootPersonSelect option').count()
    expect(optionCount).toBeGreaterThan(1)
  })

  test('selecting person renders family tree', async ({ page }) => {
    await page.goto('family-tree')
    await page.waitForFunction(() => {
      const select = document.querySelector('#rootPersonSelect') as HTMLSelectElement
      return select && select.options.length > 1
    }, { timeout: 5000 })
    await page.selectOption('#rootPersonSelect', '1')
    await page.waitForTimeout(500)
    const container = await page.locator('#familyTreeContainer').textContent()
    expect(container).toContain('John')
  })
})

test.describe('Partuturan Page - Functional Tests', () => {
  test('partuturan page loads correctly', async ({ page }) => {
    await page.goto('partuturan')
    await expect(page.locator('h1')).toContainText('Partuturan')
    await expect(page.locator('#person1Select')).toBeVisible()
    await expect(page.locator('#person2Select')).toBeVisible()
    await expect(page.locator('#calculateBtn')).toBeVisible()
  })

  test('person selects populated in partuturan', async ({ page }) => {
    await page.goto('partuturan')
    await page.waitForFunction(() => {
      const s1 = document.querySelector('#person1Select') as HTMLSelectElement
      const s2 = document.querySelector('#person2Select') as HTMLSelectElement
      return s1 && s1.options.length > 1 && s2 && s2.options.length > 1
    }, { timeout: 5000 })
    const count1 = await page.locator('#person1Select option').count()
    const count2 = await page.locator('#person2Select option').count()
    expect(count1).toBeGreaterThan(1)
    expect(count2).toBeGreaterThan(1)
  })

  test('calculate button shows alert when no person selected', async ({ page }) => {
    await page.goto('partuturan')
    page.on('dialog', async dialog => {
      expect(dialog.message()).toContain('Pilih dua anggota')
      await dialog.accept()
    })
    await page.click('#calculateBtn')
  })

  test('calculate partuturan between two related persons', async ({ page }) => {
    await page.goto('partuturan')
    await page.waitForFunction(() => {
      const s1 = document.querySelector('#person1Select') as HTMLSelectElement
      return s1 && s1.options.length > 1
    }, { timeout: 5000 })
    await page.selectOption('#person1Select', '8')
    await page.selectOption('#person2Select', '1')
    await page.click('#calculateBtn')
    await page.waitForFunction(() => {
      const result = document.querySelector('#partuturanResult')
      return result && result.textContent?.includes('Ama') || result?.textContent?.includes('Kakek')
    }, { timeout: 5000 })
    const resultText = await page.locator('#partuturanResult').textContent()
    expect(resultText).toMatch(/Ama|Kakek/)
  })
})
