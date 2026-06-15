<?php
/**
 * Database Configuration
 * Using Eloquent ORM
 */

use Illuminate\Database\Capsule\Manager as Capsule;

$capsule = new Capsule;

$capsule->addConnection([
    'driver'    => $_ENV['DB_DRIVER'] ?? 'mysql',
    'host'      => $_ENV['DB_HOST'] ?? 'localhost',
    'database'  => $_ENV['DB_NAME'] ?? 'tarombo',
    'username'  => $_ENV['DB_USER'] ?? 'root',
    'password'  => $_ENV['DB_PASS'] ?? '',
    'charset'   => 'utf8mb4',
    'collation' => 'utf8mb4_unicode_ci',
    'prefix'    => '',
    'unix_socket' => $_ENV['DB_UNIX_SOCKET'] ?? '/opt/lampp/var/mysql/mysql.sock',
]);

$capsule->setAsGlobal();
$capsule->bootEloquent();
