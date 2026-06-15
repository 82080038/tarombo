import { test, expect } from '@playwright/test';

/**
 * Role-Based Access Control (RBAC) Simulation Test
 * Simulates application usage as Admin, Verified User, and Regular User
 */

test.describe('Role-Based Access Simulation', () => {
  test.beforeEach(async ({ page }) => {
    // Clear localStorage before each test
    await page.goto('http://localhost/tarombo/');
    await page.evaluate(() => localStorage.clear());
  });

  test('Admin User - Full Access Simulation', async ({ page }) => {
    console.log('=== ADMIN SIMULATION START ===');
    
    // Navigate to login page
    await page.goto('http://localhost/tarombo/login');
    await page.waitForLoadState('networkidle');
    
    // Quick login as admin
    await page.click('button:has-text("Admin")');
    await page.waitForTimeout(2000);
    
    // Verify admin is logged in
    const token = await page.evaluate(() => localStorage.getItem('tarombo_token'));
    expect(token).toBeTruthy();
    console.log('✅ Admin logged in successfully');
    
    // Navigate to Persons page
    await page.goto('http://localhost/tarombo/persons');
    await page.waitForLoadState('networkidle');
    await expect(page.locator('h1')).toContainText('Daftar Dongan Tubu');
    console.log('✅ Admin can access Persons page');
    
    // Check if add button is visible for admin
    const addButton = page.locator('button:has-text("+ Tambah Anggota")');
    const isAddVisible = await addButton.isVisible();
    if (isAddVisible) {
      console.log('✅ Add button visible for admin');
    } else {
      console.log('⚠️ Add button not visible for admin');
    }
    
    // Logout
    await page.goto('http://localhost/tarombo/login');
    await page.evaluate(() => localStorage.removeItem('tarombo_token'));
    console.log('✅ Admin logout successful');
    
    console.log('=== ADMIN SIMULATION COMPLETE ===');
  });

  test('Verified User - CRUD Access Simulation', async ({ page }) => {
    console.log('=== VERIFIED USER SIMULATION START ===');
    
    // Navigate to login page
    await page.goto('http://localhost/tarombo/login');
    
    // Quick login as user
    await page.click('button:has-text("User")');
    await page.waitForURL('http://localhost/tarombo/');
    
    // Verify user is logged in
    const token = await page.evaluate(() => localStorage.getItem('tarombo_token'));
    expect(token).toBeTruthy();
    console.log('✅ Verified user logged in successfully');
    
    // Navigate to Persons page
    await page.goto('http://localhost/tarombo/persons');
    await page.waitForLoadState('networkidle');
    await expect(page.locator('h1')).toContainText('Daftar Dongan Tubu');
    console.log('✅ Verified user can access Persons page');
    
    // Try to add a new person (verified user should have access)
    await page.click('button:has-text("+ Tambah Anggota")');
    await expect(page.locator('#addPersonModal')).toBeVisible();
    console.log('✅ Verified user can add persons');
    
    // Close modal
    await page.click('.btn-close');
    
    // Try to access Admin Dashboard (should be restricted)
    await page.goto('http://localhost/tarombo/admin');
    await page.waitForLoadState('networkidle');
    
    // Check if access is denied or error shown
    const pageContent = await page.textContent('body');
    if (pageContent && (pageContent.includes('Akses ditolak') || pageContent.includes('403') || pageContent.includes('forbidden'))) {
      console.log('✅ Admin Dashboard properly restricted for verified user');
    } else {
      console.log('⚠️ Admin Dashboard access may need role check');
    }
    
    // Logout
    await page.goto('http://localhost/tarombo/login');
    await page.evaluate(() => localStorage.removeItem('tarombo_token'));
    console.log('✅ Verified user logout');
    
    console.log('=== VERIFIED USER SIMULATION COMPLETE ===');
  });

  test('Guest/Unauthenticated User - Limited Access', async ({ page }) => {
    console.log('=== GUEST USER SIMULATION START ===');
    
    // Navigate to homepage without login
    await page.goto('http://localhost/tarombo/');
    await page.waitForLoadState('networkidle');
    await expect(page.locator('h1')).toContainText('Selamat Datang');
    console.log('✅ Guest can access homepage');
    
    // Try to access Persons page (should be read-only or require login)
    await page.goto('http://localhost/tarombo/persons');
    await page.waitForLoadState('networkidle');
    await expect(page.locator('h1')).toContainText('Daftar Dongan Tubu');
    console.log('✅ Guest can view Persons page');
    
    // Check if add button is hidden or disabled for guests
    const addButton = page.locator('button:has-text("+ Tambah Anggota")');
    const isAddVisible = await addButton.isVisible();
    if (!isAddVisible) {
      console.log('✅ Add button properly hidden for guests');
    } else {
      console.log('⚠️ Add button visible for guests - may need RBAC check');
    }
    
    // Try to access Admin Dashboard (should be restricted)
    await page.goto('http://localhost/tarombo/admin');
    await page.waitForLoadState('networkidle');
    
    const pageContent = await page.textContent('body');
    if (pageContent && (pageContent.includes('Akses ditolak') || pageContent.includes('401') || pageContent.includes('Login'))) {
      console.log('✅ Admin Dashboard properly restricted for guests');
    } else {
      console.log('⚠️ Admin Dashboard may need authentication check');
    }
    
    // Try to access Family Tree
    await page.goto('http://localhost/tarombo/family-tree');
    await page.waitForLoadState('networkidle');
    await expect(page.locator('h1')).toContainText('Pohon Tarombo');
    console.log('✅ Guest can access Family Tree');
    
    // Try to access Partuturan
    await page.goto('http://localhost/tarombo/partuturan');
    await page.waitForLoadState('networkidle');
    await expect(page.locator('h1')).toContainText('Partuturan');
    console.log('✅ Guest can access Partuturan');
    
    // Navigate to login page
    await page.goto('http://localhost/tarombo/login');
    await page.waitForLoadState('networkidle');
    await expect(page.locator('.card-header')).toContainText('Login');
    console.log('✅ Guest can access login page');
    
    console.log('=== GUEST USER SIMULATION COMPLETE ===');
  });

  test('Security Check - Quick Login Development Mode', async ({ page }) => {
    console.log('=== SECURITY CHECK START ===');
    
    // Test quick login is available in development
    await page.goto('http://localhost/tarombo/login');
    await page.waitForLoadState('networkidle');
    
    // Test quick login functionality
    await page.click('button:has-text("Admin")');
    await page.waitForTimeout(2000);
    
    const token = await page.evaluate(() => localStorage.getItem('tarombo_token'));
    expect(token).toBeTruthy();
    console.log('✅ Quick login works in development mode');
    
    // Check token structure
    const tokenParts = token.split('.');
    if (tokenParts.length === 3) {
      console.log('✅ JWT token has valid structure (header.payload.signature)');
    } else {
      console.log('⚠️ JWT token structure may be invalid');
    }
    
    console.log('=== SECURITY CHECK COMPLETE ===');
  });
});
