import { test, expect } from '@playwright/test'

test.setTimeout(120000)

test('console errors & network failures audit', async ({ page }) => {
  const consoleErrors: string[] = []
  const networkFailures: string[] = []
  const failedRequests: string[] = []

  page.on('console', msg => {
    if (msg.type() === 'error') {
      consoleErrors.push(`[${msg.type()}] ${msg.text()}`)
    }
  })

  page.on('requestfailed', request => {
    networkFailures.push(`FAILED: ${request.method()} ${request.url()} - ${request.failure()?.errorText}`)
  })

  page.on('response', response => {
    if (response.status() >= 400) {
      failedRequests.push(`HTTP ${response.status()}: ${response.url()}`)
    }
  })

  const pages = [
    { url: '', name: 'home' },
    { url: 'persons', name: 'persons' },
    { url: 'family-tree', name: 'family-tree' },
    { url: 'partuturan', name: 'partuturan' },
    { url: 'marriages', name: 'marriages' },
    { url: 'ceremonies', name: 'ceremonies' },
    { url: 'punguan', name: 'punguan' },
    { url: 'documents', name: 'documents' },
    { url: 'makam', name: 'makam' },
    { url: 'map', name: 'map' },
    { url: 'admin', name: 'admin' },
    { url: 'login', name: 'login' },
  ]

  for (const p of pages) {
    consoleErrors.length = 0
    networkFailures.length = 0
    failedRequests.length = 0

    await page.goto(p.url, { waitUntil: 'networkidle' })
    await page.waitForTimeout(2000)

    console.log(`\n=== ${p.name} ===`)
    if (consoleErrors.length > 0) {
      console.log('CONSOLE ERRORS:')
      consoleErrors.forEach(e => console.log(`  ${e}`))
    }
    if (networkFailures.length > 0) {
      console.log('NETWORK FAILURES:')
      networkFailures.forEach(e => console.log(`  ${e}`))
    }
    if (failedRequests.length > 0) {
      console.log('HTTP ERRORS:')
      failedRequests.forEach(e => console.log(`  ${e}`))
    }
    if (consoleErrors.length === 0 && networkFailures.length === 0 && failedRequests.length === 0) {
      console.log('  No errors')
    }
  }
})

test('authenticated pages audit', async ({ page, request }) => {
  const loginRes = await request.post('http://localhost:8000/api/v1/auth/quick-login', { data: { role: 'admin' } })
  const loginBody = await loginRes.json()
  const token = loginBody.data.access_token

  const consoleErrors: string[] = []
  const networkFailures: string[] = []
  const failedRequests: string[] = []

  page.on('console', msg => {
    if (msg.type() === 'error') {
      consoleErrors.push(`[${msg.type()}] ${msg.text()}`)
    }
  })

  page.on('requestfailed', request => {
    networkFailures.push(`FAILED: ${request.method()} ${request.url()} - ${request.failure()?.errorText}`)
  })

  page.on('response', response => {
    if (response.status() >= 400) {
      failedRequests.push(`HTTP ${response.status()}: ${response.url()}`)
    }
  })

  const authPages = [
    { url: 'persons', name: 'persons (admin)' },
    { url: 'admin', name: 'admin (admin)' },
    { url: 'notifications', name: 'notifications (admin)' },
  ]

  for (const p of authPages) {
    consoleErrors.length = 0
    networkFailures.length = 0
    failedRequests.length = 0

    await page.goto('')
    await page.evaluate((t) => localStorage.setItem('tarombo_token', t), token)
    await page.goto(p.url, { waitUntil: 'networkidle' })
    await page.waitForTimeout(2000)

    console.log(`\n=== ${p.name} ===`)
    if (consoleErrors.length > 0) {
      console.log('CONSOLE ERRORS:')
      consoleErrors.forEach(e => console.log(`  ${e}`))
    }
    if (networkFailures.length > 0) {
      console.log('NETWORK FAILURES:')
      networkFailures.forEach(e => console.log(`  ${e}`))
    }
    if (failedRequests.length > 0) {
      console.log('HTTP ERRORS:')
      failedRequests.forEach(e => console.log(`  ${e}`))
    }
    if (consoleErrors.length === 0 && networkFailures.length === 0 && failedRequests.length === 0) {
      console.log('  No errors')
    }
  }
})
