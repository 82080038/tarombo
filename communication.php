<?php
$extraJs = 'communication.js';
include 'includes/header.php';
?>
<div class="container mx-auto px-4 py-8">
    <h1 class="text-3xl font-bold text-gray-800 mb-6">📢 Komunikasi</h1>
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div class="bg-white rounded-lg shadow p-4">
            <h2 class="text-xl font-bold mb-4">Pengumuman</h2>
            <div id="announcementsList" class="space-y-3"></div>
        </div>
        <div class="bg-white rounded-lg shadow p-4">
            <h2 class="text-xl font-bold mb-4">Notifikasi</h2>
            <div id="notificationsList" class="space-y-3"></div>
        </div>
    </div>
</div>
<?php include 'includes/footer.php'; ?>
