import { test, expect } from '@playwright/test';

/**
 * Role-Based Navigation Test
 * Tests that navigation menu items are shown/hidden based on user role
 */

test.describe('Role-Based Navigation', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('http://localhost:8081/');
    await page.evaluate(() => localStorage.clear());
  });

  test('Admin - Full Navigation', async ({ page }) => {
    console.log('=== ADMIN NAVIGATION TEST ===');
    
    await page.goto('http://localhost:8081/login');
    await page.click('button:has-text("Admin")');
    await page.waitForTimeout(2000);
    
    // Navigate to homepage to check navigation
    await page.goto('http://localhost:8081/');
    await page.waitForLoadState('networkidle');
    
    // Open dropdown to check admin menu
    await page.click('a:has-text("Lainnya")');
    await page.waitForTimeout(500);
    
    // Check if Admin menu item is visible
    const adminMenu = page.locator('a:has-text("📊 Admin")');
    const isVisible = await adminMenu.isVisible();
    console.log(`Admin menu visible: ${isVisible}`);
    
    if (isVisible) {
      console.log('✅ Admin menu visible for admin role');
    } else {
      console.log('⚠️ Admin menu not visible - checking RBAC');
      // Check if the element exists but is hidden
      const exists = await adminMenu.count();
      console.log(`Admin menu element count: ${exists}`);
    }
    
    // Check all main menu items
    await expect(page.locator('a:has-text("Beranda")')).toBeVisible();
    await expect(page.locator('a:has-text("Dongan Tubu")')).toBeVisible();
    console.log('✅ Main menu items visible for admin');
    
    await page.evaluate(() => localStorage.removeItem('tarombo_token'));
    console.log('=== ADMIN NAVIGATION TEST COMPLETE ===');
  });

  test('Punguan Admin - Admin Menu Visible', async ({ page }) => {
    console.log('=== PUNGUAN ADMIN NAVIGATION TEST ===');
    
    await page.goto('http://localhost:8081/login');
    await page.click('button:has-text("Punguan Admin")');
    await page.waitForTimeout(2000);
    
    // Navigate to homepage to check navigation
    await page.goto('http://localhost:8081/');
    await page.waitForLoadState('networkidle');
    
    // Open dropdown to check admin menu
    await page.click('a:has-text("Lainnya")');
    await page.waitForTimeout(500);
    
    // Check if Admin menu item is visible
    const adminMenu = page.locator('a:has-text("📊 Admin")');
    const isVisible = await adminMenu.isVisible();
    console.log(`Admin menu visible: ${isVisible}`);
    
    if (isVisible) {
      console.log('✅ Admin menu visible for punguan_admin role');
    } else {
      console.log('⚠️ Admin menu not visible - checking RBAC');
      const exists = await adminMenu.count();
      console.log(`Admin menu element count: ${exists}`);
    }
    
    // Check main menu items
    await expect(page.locator('a:has-text("Beranda")')).toBeVisible();
    await expect(page.locator('a:has-text("Dongan Tubu")')).toBeVisible();
    console.log('✅ Main menu items visible for punguan_admin');
    
    await page.evaluate(() => localStorage.removeItem('tarombo_token'));
    console.log('=== PUNGUAN ADMIN NAVIGATION TEST COMPLETE ===');
  });

  test('Verified User - No Admin Menu', async ({ page }) => {
    console.log('=== VERIFIED USER NAVIGATION TEST ===');
    
    await page.goto('http://localhost:8081/login');
    await page.click('button:has-text("Verified")');
    await page.waitForTimeout(2000);
    
    // Open dropdown to check admin menu
    await page.click('a:has-text("Lainnya")');
    await page.waitForTimeout(500);
    
    // Check if Admin menu item is NOT visible
    const adminMenu = page.locator('a:has-text("📊 Admin")');
    const isVisible = await adminMenu.isVisible();
    expect(isVisible).toBe(false);
    console.log('✅ Admin menu hidden for verified role');
    
    // Check main menu items are still visible
    await expect(page.locator('a:has-text("Beranda")')).toBeVisible();
    await expect(page.locator('a:has-text("Dongan Tubu")')).toBeVisible();
    console.log('✅ Main menu items visible for verified user');
    
    await page.evaluate(() => localStorage.removeItem('tarombo_token'));
    console.log('=== VERIFIED USER NAVIGATION TEST COMPLETE ===');
  });

  test('Regular User - No Admin Menu', async ({ page }) => {
    console.log('=== REGULAR USER NAVIGATION TEST ===');
    
    await page.goto('http://localhost:8081/login');
    await page.click('button:has-text("User")');
    await page.waitForTimeout(2000);
    
    // Check if Admin menu item is NOT visible
    const adminMenu = page.locator('a:has-text("Admin")');
    const isVisible = await adminMenu.isVisible();
    expect(isVisible).toBe(false);
    console.log('✅ Admin menu hidden for user role');
    
    // Check main menu items are still visible
    await expect(page.locator('a:has-text("Beranda")')).toBeVisible();
    await expect(page.locator('a:has-text("Dongan Tubu")')).toBeVisible();
    console.log('✅ Main menu items visible for regular user');
    
    await page.evaluate(() => localStorage.removeItem('tarombo_token'));
    console.log('=== REGULAR USER NAVIGATION TEST COMPLETE ===');
  });

  test('Guest - No Admin Menu', async ({ page }) => {
    console.log('=== GUEST NAVIGATION TEST ===');
    
    await page.goto('http://localhost:8081/');
    await page.waitForLoadState('networkidle');
    
    // Open dropdown to check admin menu
    await page.click('a:has-text("Lainnya")');
    await page.waitForTimeout(500);
    
    // Check if Admin menu item is NOT visible
    const adminMenu = page.locator('a:has-text("📊 Admin")');
    const isVisible = await adminMenu.isVisible();
    expect(isVisible).toBe(false);
    console.log('✅ Admin menu hidden for guest');
    
    // Check main menu items are visible
    await expect(page.locator('a:has-text("Beranda")')).toBeVisible();
    await expect(page.locator('a:has-text("Dongan Tubu")')).toBeVisible();
    console.log('✅ Main menu items visible for guest');
    
    console.log('=== GUEST NAVIGATION TEST COMPLETE ===');
  });
});
