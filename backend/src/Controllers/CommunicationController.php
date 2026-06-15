<?php
namespace App\Controllers;
use App\Models\Announcement;
use App\Models\Message;
use App\Models\Notification;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
class CommunicationController
{
    public function getAnnouncements(Request $request, Response $response): Response
    {
        $query = Announcement::with(['punguan', 'marga', 'pengirim']);
        $announcements = $query->where('status', 'published')->orderBy('tanggal_publish', 'desc')->get();
        return $this->jsonResponse($response, ['success' => true, 'data' => $announcements]);
    }
    public function createAnnouncement(Request $request, Response $response): Response
    {
        $body = $request->getParsedBody() ?? [];
        $announcement = Announcement::create([
            'judul' => $body['judul'],
            'konten' => $body['konten'],
            'tipe' => $body['tipe'],
            'punguan_id' => $body['punguan_id'] ?? null,
            'marga_id' => $body['marga_id'] ?? null,
            'pengirim_id' => $request->getAttribute('user_id'),
            'prioritas' => $body['prioritas'] ?? 'normal',
            'status' => 'draft',
            'tanggal_publish' => null
        ]);
        return $this->jsonResponse($response, ['success' => true, 'data' => $announcement], 201);
    }
    public function publishAnnouncement(Request $request, Response $response, array $args): Response
    {
        $id = (int)$args['id'];
        $announcement = Announcement::find($id);
        if (!$announcement) {
            return $this->jsonResponse($response, ['success' => false, 'error' => 'Announcement not found'], 404);
        }
        $announcement->status = 'published';
        $announcement->tanggal_publish = now();
        $announcement->save();
        return $this->jsonResponse($response, ['success' => true, 'data' => $announcement]);
    }
    public function getMessages(Request $request, Response $response): Response
    {
        $userId = $request->getAttribute('user_id');
        $query = Message::with(['pengirim', 'penerima', 'replies']);
        $messages = $query->where('penerima_id', $userId)->orWhere('pengirim_id', $userId)->orderBy('created_at', 'desc')->get();
        return $this->jsonResponse($response, ['success' => true, 'data' => $messages]);
    }
    public function createMessage(Request $request, Response $response): Response
    {
        $body = $request->getParsedBody() ?? [];
        $message = Message::create([
            'pengirim_id' => $request->getAttribute('user_id'),
            'penerima_id' => $body['penerima_id'] ?? null,
            'subjek' => $body['subjek'] ?? null,
            'konten' => $body['konten'],
            'status' => 'terkirim',
            'parent_id' => $body['parent_id'] ?? null
        ]);
        return $this->jsonResponse($response, ['success' => true, 'data' => $message], 201);
    }
    public function getNotifications(Request $request, Response $response): Response
    {
        $userId = $request->getAttribute('user_id');
        $status = $request->getQueryParams()['status'] ?? null;
        $type = $request->getQueryParams()['type'] ?? null;
        $entityType = $request->getQueryParams()['entity_type'] ?? null;
        
        $query = Notification::where('user_id', $userId);
        
        if ($status === 'unread') {
            $query->where('is_read', false);
        } elseif ($status === 'read') {
            $query->where('is_read', true);
        }
        
        if ($type) {
            $query->where('type', $type);
        }
        
        if ($entityType) {
            $query->where('entity_type', $entityType);
        }
        
        $notifications = $query->orderBy('created_at', 'desc')->get();
        return $this->jsonResponse($response, ['success' => true, 'data' => $notifications]);
    }
    public function markNotificationRead(Request $request, Response $response, array $args): Response
    {
        $id = (int)$args['id'];
        $notification = Notification::find($id);
        if (!$notification) {
            return $this->jsonResponse($response, ['success' => false, 'error' => 'Notification not found'], 404);
        }
        $notification->is_read = true;
        $notification->read_at = now();
        $notification->save();
        return $this->jsonResponse($response, ['success' => true, 'data' => $notification]);
    }
    
    public function markAllNotificationsRead(Request $request, Response $response): Response
    {
        $userId = $request->getAttribute('user_id');
        Notification::where('user_id', $userId)
            ->where('is_read', false)
            ->update(['is_read' => true, 'read_at' => now()]);
        return $this->jsonResponse($response, ['success' => true, 'message' => 'All notifications marked as read']);
    }
    
    public function getUnreadCount(Request $request, Response $response): Response
    {
        $userId = $request->getAttribute('user_id');
        $count = Notification::where('user_id', $userId)
            ->where('is_read', false)
            ->count();
        return $this->jsonResponse($response, ['success' => true, 'data' => ['count' => $count]]);
    }
    private function jsonResponse(Response $response, array $data, int $status = 200): Response
    {
        $response->getBody()->write(json_encode($data));
        return $response->withHeader('Content-Type', 'application/json')->withStatus($status);
    }
}
