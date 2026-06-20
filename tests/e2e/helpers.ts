import { APIRequestContext } from '@playwright/test'

/**
 * Get an admin auth token via quick-login endpoint
 */
export async function getAdminToken(request: APIRequestContext): Promise<string> {
  const res = await request.post('http://localhost:8000/api/v1/auth/quick-login', {
    data: { role: 'admin' }
  })
  const body = await res.json()
  return body.data.access_token
}

/**
 * Inject auth token into page localStorage before navigating to protected pages
 */
export async function injectAuthToken(page: import('@playwright/test').Page, request: APIRequestContext): Promise<string> {
  const token = await getAdminToken(request)
  await page.goto('')
  await page.evaluate((t) => localStorage.setItem('tarombo_token', t), token)
  return token
}

/**
 * Get auth headers for API requests
 */
export async function authHeaders(request: APIRequestContext): Promise<Record<string, string>> {
  const token = await getAdminToken(request)
  return { Authorization: `Bearer ${token}` }
}
