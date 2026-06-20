<?php
/**
 * Email Service
 * Handles sending emails for password reset, email verification, and notifications
 * Uses PHP mail() by default — configure SMTP via .env for production
 */

namespace App\Services;

class EmailService
{
    private string $fromEmail;
    private string $fromName;
    private ?string $smtpHost;
    private ?int $smtpPort;
    private ?string $smtpUser;
    private ?string $smtpPass;

    public function __construct()
    {
        $this->fromEmail = $_ENV['MAIL_FROM_EMAIL'] ?? 'noreply@tarombo.local';
        $this->fromName = $_ENV['MAIL_FROM_NAME'] ?? 'Tarombo Digital';
        $this->smtpHost = $_ENV['SMTP_HOST'] ?? null;
        $this->smtpPort = (int)($_ENV['SMTP_PORT'] ?? 587);
        $this->smtpUser = $_ENV['SMTP_USER'] ?? null;
        $this->smtpPass = $_ENV['SMTP_PASS'] ?? null;
    }

    /**
     * Send password reset email
     */
    public function sendPasswordReset(string $toEmail, string $resetToken): void
    {
        $resetUrl = ($_ENV['APP_URL'] ?? 'http://localhost/tarombo') . '/reset-password?token=' . $resetToken;

        $subject = 'Reset Password - Tarombo Digital';
        $body = $this->renderTemplate('password_reset', [
            'reset_url' => $resetUrl,
            'expiry' => '1 jam'
        ]);

        $this->send($toEmail, $subject, $body);
    }

    /**
     * Send email verification
     */
    public function sendEmailVerification(string $toEmail, string $verifyToken): void
    {
        $verifyUrl = ($_ENV['APP_URL'] ?? 'http://localhost/tarombo') . '/verify-email?token=' . $verifyToken;

        $subject = 'Verifikasi Email - Tarombo Digital';
        $body = $this->renderTemplate('email_verification', [
            'verify_url' => $verifyUrl
        ]);

        $this->send($toEmail, $subject, $body);
    }

    /**
     * Send notification email
     */
    public function sendNotification(string $toEmail, string $title, string $message): void
    {
        $subject = $title . ' - Tarombo Digital';
        $body = $this->renderTemplate('notification', [
            'title' => $title,
            'message' => $message
        ]);

        $this->send($toEmail, $subject, $body);
    }

    /**
     * Send email using configured method
     */
    private function send(string $to, string $subject, string $body): void
    {
        $headers = [
            'MIME-Version: 1.0',
            'Content-Type: text/html; charset=UTF-8',
            'From: ' . $this->fromName . ' <' . $this->fromEmail . '>',
            'Reply-To: ' . $this->fromEmail,
            'X-Mailer: PHP/' . phpversion()
        ];

        if ($this->smtpHost) {
            $this->sendViaSmtp($to, $subject, $body);
        } else {
            mail($to, $subject, $body, implode("\r\n", $headers));
        }
    }

    /**
     * Send via SMTP using fsockopen (no external dependency)
     */
    private function sendViaSmtp(string $to, string $subject, string $body): void
    {
        // Basic SMTP implementation — for production use PHPMailer
        $socket = @fsockopen($this->smtpHost, $this->smtpPort, $errno, $errstr, 10);
        if (!$socket) {
            throw new \RuntimeException("SMTP connection failed: $errstr ($errno)");
        }

        $this->smtpRead($socket);
        $this->smtpSend($socket, "EHLO tarombo.local");
        $this->smtpSend($socket, "STARTTLS");
        $this->smtpSend($socket, "EHLO tarombo.local");
        $this->smtpSend($socket, "AUTH LOGIN");
        $this->smtpSend($socket, base64_encode($this->smtpUser));
        $this->smtpSend($socket, base64_encode($this->smtpPass));
        $this->smtpSend($socket, "MAIL FROM:<{$this->fromEmail}>");
        $this->smtpSend($socket, "RCPT TO:<$to>");
        $this->smtpSend($socket, "DATA");
        $this->smtpSend($socket, "Subject: $subject\r\nTo: $to\r\nContent-Type: text/html; charset=UTF-8\r\n\r\n$body\r\n.");
        $this->smtpSend($socket, "QUIT");

        fclose($socket);
    }

    private function smtpSend($socket, string $data): string
    {
        fputs($socket, $data . "\r\n");
        return $this->smtpRead($socket);
    }

    private function smtpRead($socket): string
    {
        $response = '';
        while ($line = fgets($socket, 515)) {
            $response .= $line;
            if (substr($line, 3, 1) === ' ') break;
        }
        return $response;
    }

    /**
     * Render email template
     */
    private function renderTemplate(string $template, array $vars): string
    {
        $templates = [
            'password_reset' => '<!DOCTYPE html><html><body style="font-family:Arial,sans-serif;max-width:600px;margin:0 auto;">
<h2 style="color:#2c5282;">Reset Password Tarombo Digital</h2>
<p>Anda telah meminta reset password. Klik tombol di bawah untuk mereset password Anda:</p>
<p><a href="{reset_url}" style="display:inline-block;background:#2c5282;color:#fff;padding:12px 24px;text-decoration:none;border-radius:4px;">Reset Password</a></p>
<p style="color:#666;font-size:12px;">Link ini berlaku selama {expiry}. Jika Anda tidak meminta reset password, abaikan email ini.</p>
<hr><p style="color:#999;font-size:11px;">Tarombo Digital - Sistem Genealogi Keluarga Batak</p>
</body></html>',
            'email_verification' => '<!DOCTYPE html><html><body style="font-family:Arial,sans-serif;max-width:600px;margin:0 auto;">
<h2 style="color:#2c5282;">Verifikasi Email Tarombo Digital</h2>
<p>Selamat datang! Klik tombol di bawah untuk memverifikasi email Anda:</p>
<p><a href="{verify_url}" style="display:inline-block;background:#2c5282;color:#fff;padding:12px 24px;text-decoration:none;border-radius:4px;">Verifikasi Email</a></p>
<hr><p style="color:#999;font-size:11px;">Tarombo Digital - Sistem Genealogi Keluarga Batak</p>
</body></html>',
            'notification' => '<!DOCTYPE html><html><body style="font-family:Arial,sans-serif;max-width:600px;margin:0 auto;">
<h2 style="color:#2c5282;">{title}</h2>
<p>{message}</p>
<hr><p style="color:#999;font-size:11px;">Tarombo Digital - Sistem Genealogi Keluarga Batak</p>
</body></html>'
        ];

        $template = $templates[$template] ?? $templates['notification'];
        foreach ($vars as $key => $value) {
            $template = str_replace('{' . $key . '}', $value, $template);
        }
        return $template;
    }
}
