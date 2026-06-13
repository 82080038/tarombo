import { test, expect } from '@playwright/test'

// Capture console logs and network responses for all tests
let consoleLogs: Array<{ type: string; text: string }> = []
let networkResponses: Array<{ url: string; status: number }> = []

test.beforeEach(async ({ page }) => {
  consoleLogs = []
  networkResponses = []

  page.on('console', (msg) => {
    consoleLogs.push({ type: msg.type(), text: msg.text() })
  })

  page.on('response', (response) => {
    networkResponses.push({
      url: response.url(),
      status: response.status(),
    })
  })
})

test.afterEach(async ({ }, testInfo) => {
  if (testInfo.status !== 'passed') {
    console.log(`\n=== Console logs for: ${testInfo.title} ===`)
    consoleLogs.forEach((log) => console.log(`[${log.type}] ${log.text}`))
    console.log(`\n=== Network responses for: ${testInfo.title} ===`)
    networkResponses.forEach((res) => console.log(`[${res.status}] ${res.url}`))
  }
})

test.describe('Homepage', () => {
  test('loads with correct title and navbar', async ({ page }) => {
    await page.goto('')
    await expect(page).toHaveTitle(/Tarombo Digital/)
    await expect(page.locator('h1')).toContainText('Horas! Selamat Datang')
    await expect(page.locator('.navbar-brand')).toContainText('Tarombo Digital')

    // Check navigation links exist (navbar only)
    await expect(page.locator('.navbar-nav a[href="persons.html"]')).toBeVisible()
    await expect(page.locator('.navbar-nav a[href="family-tree.html"]')).toBeVisible()
    await expect(page.locator('.navbar-nav a[href="partuturan.html"]')).toBeVisible()
  })

  test('navigates to all pages from homepage', async ({ page }) => {
    await page.goto('')

    // Persons
    await page.click('a[href="persons.html"]')
    await expect(page).toHaveURL(/persons\.html/)
    await expect(page.locator('h1')).toContainText('Daftar Dongan Tubu')

    // Back to home
    await page.goto('')

    // Family Tree
    await page.click('a[href="family-tree.html"]')
    await expect(page).toHaveURL(/family-tree\.html/)
    await expect(page.locator('h1')).toContainText('Pohon Tarombo')

    // Back to home
    await page.goto('')

    // Partuturan
    await page.click('a[href="partuturan.html"]')
    await expect(page).toHaveURL(/partuturan\.html/)
    await expect(page.locator('h1')).toContainText('Partuturan')
  })
})

test.describe('Persons Page', () => {
  test('loads and displays person data from API', async ({ page }) => {
    await page.goto('persons.html')
    await expect(page.locator('h1')).toContainText('Daftar Dongan Tubu')

    // Wait for API data to load (table rows appear, not just loading row)
    await page.waitForFunction(() => {
      const tbody = document.querySelector('#personsTable')
      return tbody && tbody.children.length > 1 && !tbody.textContent?.includes('Loading')
    }, { timeout: 10000 })
    const rows = await page.locator('#personsTable tr').count()
    expect(rows).toBeGreaterThan(0)

    // Verify at least one person name is shown
    const tableText = await page.locator('#personsTable').textContent()
    expect(tableText).toMatch(/John|Sarah|Michael|Emily|David|Alice|Charlie|Emma/)
  })

  test('search filter works', async ({ page }) => {
    await page.goto('persons.html')
    await page.waitForSelector('#personsTable tr', { timeout: 10000 })

    // Type search
    await page.fill('#searchInput', 'John')
    await page.waitForTimeout(500)

    const rows = await page.locator('#personsTable tr').count()
    expect(rows).toBeGreaterThanOrEqual(1)

    const firstRow = await page.locator('#personsTable tr').first().textContent()
    expect(firstRow).toContain('John')
  })

  test('add person modal opens', async ({ page }) => {
    await page.goto('persons.html')
    await page.click('button[data-bs-target="#addPersonModal"]')
    await expect(page.locator('#addPersonModal')).toBeVisible()

    // Check marga dropdown populated
    await page.waitForFunction(() => {
      const select = document.querySelector('#margaSelect') as HTMLSelectElement
      return select && select.options.length > 1
    }, { timeout: 5000 })

    const options = await page.locator('#margaSelect option').count()
    expect(options).toBeGreaterThan(1)

    // Close modal
    await page.click('#addPersonModal .btn-close')
    await expect(page.locator('#addPersonModal')).not.toBeVisible()
  })
})

test.describe('Family Tree Page', () => {
  test('loads and populates root person select', async ({ page }) => {
    await page.goto('family-tree.html')
    await expect(page.locator('h1')).toContainText('Pohon Tarombo')

    // Wait for select to populate
    await page.waitForFunction(() => {
      const select = document.querySelector('#rootPersonSelect') as HTMLSelectElement
      return select && select.options.length > 1
    }, { timeout: 10000 })

    const options = await page.locator('#rootPersonSelect option').count()
    expect(options).toBeGreaterThan(1)
  })

  test('selecting person renders family tree', async ({ page }) => {
    await page.goto('family-tree.html')

    await page.waitForFunction(() => {
      const select = document.querySelector('#rootPersonSelect') as HTMLSelectElement
      return select && select.options.length > 1
    }, { timeout: 10000 })

    // Select first real person (skip empty option)
    await page.selectOption('#rootPersonSelect', '1')

    // Wait for tree to render
    await page.waitForTimeout(1000)

    const container = await page.locator('#familyTreeContainer').textContent()
    expect(container).toContain('John')
  })
})

test.describe('Partuturan Page', () => {
  test('loads and populates person selects', async ({ page }) => {
    await page.goto('partuturan.html')
    await expect(page.locator('h1')).toContainText('Partuturan')

    // Wait for selects to populate
    await page.waitForFunction(() => {
      const s1 = document.querySelector('#person1Select') as HTMLSelectElement
      const s2 = document.querySelector('#person2Select') as HTMLSelectElement
      return s1 && s1.options.length > 1 && s2 && s2.options.length > 1
    }, { timeout: 10000 })

    const count1 = await page.locator('#person1Select option').count()
    const count2 = await page.locator('#person2Select option').count()
    expect(count1).toBeGreaterThan(1)
    expect(count2).toBeGreaterThan(1)
  })

  test('calculate button shows alert when no person selected', async ({ page }) => {
    await page.goto('partuturan.html')

    page.on('dialog', async (dialog) => {
      expect(dialog.message()).toContain('Pilih dua anggota')
      await dialog.accept()
    })

    await page.click('#calculateBtn')
  })

  test('calculates partuturan between related persons', async ({ page }) => {
    await page.goto('partuturan.html')

    await page.waitForFunction(() => {
      const s1 = document.querySelector('#person1Select') as HTMLSelectElement
      return s1 && s1.options.length > 1
    }, { timeout: 10000 })

    await page.selectOption('#person1Select', '8') // Alice Marbun
    await page.selectOption('#person2Select', '1') // John Simanjuntak

    await page.click('#calculateBtn')

    // Wait for result
    await page.waitForFunction(() => {
      const result = document.querySelector('#partuturanResult')
      return result && (
        result.textContent?.includes('Ama') ||
        result.textContent?.includes('Kakek') ||
        result.textContent?.includes('Hubungan')
      )
    }, { timeout: 10000 })

    const resultText = await page.locator('#partuturanResult').textContent()
    expect(resultText).toMatch(/Ama|Kakek|Hubungan/)
  })
})

test.describe('API Backend (via Apache proxy)', () => {
  test('health check via /tarombo/api/v1/ root', async ({ request }) => {
    // Note: backend root is just / not /api/v1/ for health check
    const response = await request.get('http://localhost:8000/')
    expect(response.status()).toBe(200)
    const body = await response.json()
    expect(body.status).toBe('ok')
  })

  test('GET persons via proxy', async ({ request }) => {
    const response = await request.get('api/v1/persons')
    expect(response.status()).toBe(200)
    const body = await response.json()
    expect(body).toHaveProperty('data')
    expect(Array.isArray(body.data)).toBeTruthy()
    expect(body.meta.total).toBeGreaterThan(0)
  })

  test('GET marga via proxy', async ({ request }) => {
    const response = await request.get('api/v1/marga')
    expect(response.status()).toBe(200)
    const body = await response.json()
    expect(body).toHaveProperty('data')
    expect(body.total).toBeGreaterThan(0)
  })

  test('GET partuturan calculate via proxy', async ({ request }) => {
    const response = await request.get('api/v1/partuturan/calculate?from=8&to=1')
    expect(response.status()).toBe(200)
    const body = await response.json()
    expect(body).toHaveProperty('relationship')
    expect(body).toHaveProperty('indonesian')
    expect(body.from_person.id).toBe(8)
    expect(body.to_person.id).toBe(1)
  })
})

test.describe('Console & Network Check', () => {
  test('no critical console errors on any page', async ({ page }) => {
    const pages = ['index.html', 'persons.html', 'family-tree.html', 'partuturan.html']

    for (const path of pages) {
      consoleLogs = []
      await page.goto(path)
      await page.waitForLoadState('networkidle')
      await page.waitForTimeout(1000)

      const errors = consoleLogs.filter((l) => l.type === 'error')
      const warnings = consoleLogs.filter((l) => l.type === 'warning')

      // Log for visibility
      if (errors.length > 0) {
        console.log(`[${path}] Console errors:`, errors.map((e) => e.text))
      }
      if (warnings.length > 0) {
        console.log(`[${path}] Console warnings:`, warnings.map((w) => w.text))
      }

      // We allow some warnings but no critical errors
      const criticalErrors = errors.filter((e) =>
        e.text.includes('Failed to load') ||
        e.text.includes('Uncaught') ||
        e.text.includes('404')
      )
      expect(criticalErrors.length, `Critical errors on ${path}: ${criticalErrors.map((e) => e.text).join(', ')}`).toBe(0)
    }
  })

  test('all API requests return 200', async ({ page }) => {
    networkResponses = []
    await page.goto('persons.html')
    await page.waitForLoadState('networkidle')
    await page.waitForTimeout(2000)

    const apiResponses = networkResponses.filter((r) => r.url.includes('/api/v1/'))
    console.log('API requests made:', apiResponses.map((r) => `${r.status} ${r.url}`))

    for (const res of apiResponses) {
      expect(res.status, `API ${res.url} returned ${res.status}`).toBe(200)
    }
  })
})

test.describe('Authentication', () => {
  test('login page loads with quick login dev buttons', async ({ page }) => {
    await page.goto('login.html')
    await expect(page.locator('h2')).toContainText('Tarombo Digital')
    await expect(page.locator('#loginForm')).toBeVisible()
    await expect(page.locator('button[type="submit"]')).toContainText('Masuk')

    // Quick login should be visible on localhost
    const devSection = page.locator('#devSection')
    if (await devSection.isVisible().catch(() => false)) {
      await expect(page.locator('button[data-role="admin"]')).toBeVisible()
      await expect(page.locator('button[data-role="user"]')).toBeVisible()
    }
  })

  test('quick login works and redirects to homepage', async ({ page }) => {
    await page.goto('login.html')
    const devSection = page.locator('#devSection')
    if (await devSection.isVisible().catch(() => false)) {
      await page.click('button[data-role="admin"]')
      await expect(page).toHaveURL(/index\.html/)
      // Navbar should show user dropdown
      await expect(page.locator('#authNavItem')).toContainText('Administrator')
    } else {
      test.skip(true, 'Quick login not available in this environment')
    }
  })

  test('register page loads', async ({ page }) => {
    await page.goto('register.html')
    await expect(page.locator('h2')).toContainText('Tarombo Digital')
    await expect(page.locator('#registerForm')).toBeVisible()
  })

  test('me endpoint returns user with valid token', async ({ request }) => {
    const loginResponse = await request.post('api/v1/auth/login', {
      data: { email: 'admin@tarombo.digital', password: 'password' }
    })
    const loginBody = await loginResponse.json()
    expect(loginBody.success).toBe(true)
    expect(loginBody.data.access_token).toBeDefined()

    const meResponse = await request.get('api/v1/auth/me', {
      headers: { Authorization: `Bearer ${loginBody.data.access_token}` }
    })
    expect(meResponse.status()).toBe(200)
    const meBody = await meResponse.json()
    expect(meBody.success).toBe(true)
    expect(meBody.data.email).toBe('admin@tarombo.digital')
    expect(meBody.data.role).toBe('admin')
  })

  test('login with wrong password returns 401', async ({ request }) => {
    const response = await request.post('api/v1/auth/login', {
      data: { email: 'admin@tarombo.digital', password: 'wrongpassword' }
    })
    expect(response.status()).toBe(401)
    const body = await response.json()
    expect(body.success).toBe(false)
    expect(body.error.code).toBe('INVALID_CREDENTIALS')
  })

  test('quick-login endpoint returns token', async ({ request }) => {
    const response = await request.post('api/v1/auth/quick-login', {
      data: { role: 'admin' }
    })
    expect(response.status()).toBe(200)
    const body = await response.json()
    expect(body.success).toBe(true)
    expect(body.data.access_token).toBeDefined()
    expect(body.data.quick_login).toBe(true)
  })
})

test.describe('Marriages Page', () => {
  test('loads marriage data and displays progress', async ({ page }) => {
    await page.goto('marriages.html')
    await expect(page.locator('h2')).toContainText('Perkawinan')
    // Wait for table to populate
    await page.waitForFunction(() => {
      const tbody = document.querySelector('#marriagesTable')
      return tbody && tbody.children.length > 0 && !tbody.textContent?.includes('Memuat')
    }, { timeout: 10000 })
    const rows = await page.locator('#marriagesTable tr').count()
    expect(rows).toBeGreaterThan(0)
  })
})

test.describe('Ceremonies Page', () => {
  test('loads ceremony page', async ({ page }) => {
    await page.goto('ceremonies.html')
    await expect(page.locator('h2')).toContainText('Acara Adat')
  })
})

test.describe('Persons Page Filters', () => {
  test('filter by gender works', async ({ page }) => {
    await page.goto('persons.html')
    await page.waitForFunction(() => {
      const tbody = document.querySelector('#personsTable')
      return tbody && tbody.children.length > 0 && !tbody.textContent?.includes('Memuat')
    }, { timeout: 10000 })
    await page.selectOption('#filterGender', 'L')
    const text = await page.locator('#personsTable').textContent()
    expect(text).not.toContain('Perempuan')
  })
})

test.describe('AI Assistant Page', () => {
  test('loads and answers knowledge question', async ({ page }) => {
    await page.goto('assistant.html')
    await expect(page.locator('.card-header')).toContainText('AI Tarombo Assistant')
    // Click suggestion chip
    await page.click('.suggestion-chip:has-text("Dalihan Na Tolu")')
    await page.waitForTimeout(500)
    const chat = await page.locator('#chatBox').textContent()
    expect(chat).toContain('Dalihan Na Tolu')
  })
})
