<?php
namespace App\Controllers;
use App\Models\Event;
use App\Models\EventAttendee;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
class EventController
{
    public function index(Request $request, Response $response): Response
    {
        $query = Event::with(['punguan', 'person', 'creator', 'attendees.person']);
        $events = $query->orderBy('tanggal_mulai', 'desc')->get();
        return $this->jsonResponse($response, ['success' => true, 'data' => $events]);
    }
    public function show(Request $request, Response $response, array $args): Response
    {
        $id = (int)$args['id'];
        $event = Event::with(['punguan', 'person', 'creator', 'attendees.person'])->find($id);
        if (!$event) {
            return $this->jsonResponse($response, ['success' => false, 'error' => 'Event not found'], 404);
        }
        return $this->jsonResponse($response, ['success' => true, 'data' => $event]);
    }
    public function store(Request $request, Response $response): Response
    {
        $body = $request->getParsedBody() ?? [];
        $event = Event::create([
            'judul' => $body['judul'],
            'deskripsi' => $body['deskripsi'] ?? null,
            'tipe' => $body['tipe'] ?? 'lainnya',
            'tanggal_mulai' => $body['tanggal_mulai'],
            'tanggal_selesai' => $body['tanggal_selesai'] ?? null,
            'lokasi' => $body['lokasi'] ?? null,
            'latitude' => $body['latitude'] ?? null,
            'longitude' => $body['longitude'] ?? null,
            'punguan_id' => $body['punguan_id'] ?? null,
            'person_id' => $body['person_id'] ?? null,
            'max_peserta' => $body['max_peserta'] ?? null,
            'status' => 'terjadwal',
            'created_by' => $request->getAttribute('user_id')
        ]);
        return $this->jsonResponse($response, ['success' => true, 'data' => $event], 201);
    }
    public function update(Request $request, Response $response, array $args): Response
    {
        $id = (int)$args['id'];
        $body = $request->getParsedBody() ?? [];
        $event = Event::find($id);
        if (!$event) {
            return $this->jsonResponse($response, ['success' => false, 'error' => 'Event not found'], 404);
        }
        $event->update($body);
        return $this->jsonResponse($response, ['success' => true, 'data' => $event]);
    }
    public function destroy(Request $request, Response $response, array $args): Response
    {
        $id = (int)$args['id'];
        $event = Event::find($id);
        if (!$event) {
            return $this->jsonResponse($response, ['success' => false, 'error' => 'Event not found'], 404);
        }
        $event->delete();
        return $this->jsonResponse($response, ['success' => true, 'message' => 'Event deleted']);
    }
    public function addAttendee(Request $request, Response $response, array $args): Response
    {
        $id = (int)$args['id'];
        $body = $request->getParsedBody() ?? [];
        $attendee = EventAttendee::create([
            'event_id' => $id,
            'person_id' => $body['person_id'],
            'status' => 'menunggu',
            'catatan' => $body['catatan'] ?? null
        ]);
        return $this->jsonResponse($response, ['success' => true, 'data' => $attendee], 201);
    }
    public function updateAttendee(Request $request, Response $response, array $args): Response
    {
        $id = (int)$args['id'];
        $attendeeId = (int)$args['attendee_id'];
        $body = $request->getParsedBody() ?? [];
        $attendee = EventAttendee::where('event_id', $id)->where('id', $attendeeId)->first();
        if (!$attendee) {
            return $this->jsonResponse($response, ['success' => false, 'error' => 'Attendee not found'], 404);
        }
        $attendee->update(['status' => $body['status'], 'catatan' => $body['catatan'] ?? $attendee->catatan, 'tanggal_respon' => now()]);
        return $this->jsonResponse($response, ['success' => true, 'data' => $attendee]);
    }
    private function jsonResponse(Response $response, array $data, int $status = 200): Response
    {
        $response->getBody()->write(json_encode($data));
        return $response->withHeader('Content-Type', 'application/json')->withStatus($status);
    }
}
