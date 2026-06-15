import { defineConfig, devices } from '@playwright/test'

export default defineConfig({
  testDir: './e2e',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: [['html', { open: 'never' }]],
  use: {
    baseURL: 'http://localhost:8081/',
    trace: 'retain-on-failure',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
    // Enable console and network monitoring
    ignoreHTTPSErrors: true,
  },
  // Use different port for backend API
  webServer: {
    command: 'cd /opt/lampp/htdocs/tarombo/backend/public && php -S localhost:9000',
    port: 9000,
    timeout: 120000,
  },
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
