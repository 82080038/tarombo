import { defineConfig, devices } from '@playwright/test'

export default defineConfig({
  testDir: './e2e',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: [['html', { open: 'never' }]],
  use: {
    baseURL: 'http://localhost/tarombo/',
    trace: 'retain-on-failure',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
    // Enable console and network monitoring
    ignoreHTTPSErrors: true,
  },
  // Frontend served by Apache on port 80, backend on port 8000
  // No webServer needed — Apache already running via XAMPP
  projects: [
    {
      name: 'chromium',
      use: { 
        ...devices['Desktop Chrome'],
        // Capture console logs
        contextOptions: {
          javaScriptEnabled: true,
        },
      },
    },
  ],
})
