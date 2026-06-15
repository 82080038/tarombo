<?php
/**
 * Tarombo Digital - Router
 * Serves frontend files and proxies API requests to backend
 */

$path = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$base = '/tarombo';
$relative = substr($path, strlen($base));
$relative = ltrim($relative, '/');

// Backend API requests - let them be handled by backend/index.php directly
if (strpos($relative, 'backend/public/') === 0) {
    $backendFile = __DIR__ . '/' . $relative;
    if (file_exists($backendFile) && is_file($backendFile)) {
        require $backendFile;
        exit;
    }
}

// API requests - proxy to backend PHP server on port 8000
if (strpos($relative, 'api/') === 0) {
    // Remove 'backend/public/' prefix if present
    $apiPath = preg_replace('#^backend/public/#', '', $relative);
    $url = 'http://localhost:8000/' . $apiPath;
    if (!empty($_SERVER['QUERY_STRING'])) {
        $url .= '?' . $_SERVER['QUERY_STRING'];
    }

    $headerLines = [];
    if (isset($_SERVER['CONTENT_TYPE'])) {
        $headerLines[] = 'Content-Type: ' . $_SERVER['CONTENT_TYPE'];
    }
    if (isset($_SERVER['HTTP_AUTHORIZATION'])) {
        $headerLines[] = 'Authorization: ' . $_SERVER['HTTP_AUTHORIZATION'];
    }
    $headerStr = implode("\r\n", $headerLines);

    $opts = [
        'http' => [
            'method'  => $_SERVER['REQUEST_METHOD'],
            'header'  => $headerStr,
            'ignore_errors' => true,
        ]
    ];

    // Forward body for POST/PUT/PATCH
    if (in_array($_SERVER['REQUEST_METHOD'], ['POST', 'PUT', 'PATCH'])) {
        $body = file_get_contents('php://input');
        $opts['http']['content'] = $body;
    }

    $context = stream_context_create($opts);
    $response = file_get_contents($url, false, $context);

    if (isset($http_response_header)) {
        foreach ($http_response_header as $header) {
            if (strpos($header, 'HTTP/') === 0) {
                preg_match('/HTTP\/\d\.\d\s+(\d+)/', $header, $m);
                if (isset($m[1])) {
                    http_response_code((int)$m[1]);
                }
            } elseif (stripos($header, 'Content-Type:') === 0) {
                header($header);
            }
        }
    }

    echo $response;
    exit;
}

// Frontend files — prefer .php over .html
if (empty($relative)) {
    $relative = 'index';
}

// If relative already has extension, use it as-is; otherwise try .php then .html
$ext = pathinfo($relative, PATHINFO_EXTENSION);
if ($ext) {
    $frontendFile = __DIR__ . '/frontend/' . $relative;
    if (file_exists($frontendFile) && is_file($frontendFile)) {
        if ($ext === 'php') {
            require $frontendFile;
        } else {
            $mimeTypes = [
                'html' => 'text/html',
                'css'  => 'text/css',
                'js'   => 'application/javascript',
                'json' => 'application/json',
                'png'  => 'image/png',
                'jpg'  => 'image/jpeg',
                'jpeg' => 'image/jpeg',
                'gif'  => 'image/gif',
                'svg'  => 'image/svg+xml',
                'ico'  => 'image/x-icon',
            ];
            if (isset($mimeTypes[$ext])) {
                header('Content-Type: ' . $mimeTypes[$ext]);
            }
            readfile($frontendFile);
        }
        exit;
    }
} else {
    $phpFile = __DIR__ . '/frontend/' . $relative . '.php';
    $htmlFile = __DIR__ . '/frontend/' . $relative . '.html';

    if (file_exists($phpFile) && is_file($phpFile)) {
        require $phpFile;
        exit;
    }

    if (file_exists($htmlFile) && is_file($htmlFile)) {
        $mimeTypes = [
            'html' => 'text/html',
            'css'  => 'text/css',
            'js'   => 'application/javascript',
            'json' => 'application/json',
            'png'  => 'image/png',
            'jpg'  => 'image/jpeg',
            'jpeg' => 'image/jpeg',
            'gif'  => 'image/gif',
            'svg'  => 'image/svg+xml',
            'ico'  => 'image/x-icon',
        ];
        $fext = pathinfo($htmlFile, PATHINFO_EXTENSION);
        if (isset($mimeTypes[$fext])) {
            header('Content-Type: ' . $mimeTypes[$fext]);
        }
        readfile($htmlFile);
        exit;
    }
}

// Static assets (js, css, images)
$staticFile = __DIR__ . '/frontend/' . $relative;
if (file_exists($staticFile) && is_file($staticFile)) {
    $ext = pathinfo($staticFile, PATHINFO_EXTENSION);
    $mimeTypes = [
        'html' => 'text/html',
        'css'  => 'text/css',
        'js'   => 'application/javascript',
        'json' => 'application/json',
        'png'  => 'image/png',
        'jpg'  => 'image/jpeg',
        'jpeg' => 'image/jpeg',
        'gif'  => 'image/gif',
        'svg'  => 'image/svg+xml',
        'ico'  => 'image/x-icon',
    ];
    if (isset($mimeTypes[$ext])) {
        header('Content-Type: ' . $mimeTypes[$ext]);
    }
    readfile($staticFile);
    exit;
}

// SPA fallback
$indexPhp = __DIR__ . '/frontend/index.php';
$indexHtml = __DIR__ . '/frontend/index.html';
if (file_exists($indexPhp)) {
    require $indexPhp;
    exit;
}
if (file_exists($indexHtml)) {
    header('Content-Type: text/html');
    readfile($indexHtml);
    exit;
}

http_response_code(404);
echo 'Not Found';
