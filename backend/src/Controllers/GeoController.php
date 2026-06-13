<?php
/**
 * Geo Controller
 * Geographic distribution and map data
 */

namespace App\Controllers;

use App\Models\PersonLocation;
use App\Models\Makam;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;

class GeoController
{
    public function personLocations(Request $request, Response $response): Response
    {
        $params = $request->getQueryParams();
        $query = PersonLocation::with('person.marga')->whereHas('person', function ($q) {
            $q->where('status', 'active');
        });
        if (!empty($params['marga_id'])) $query->whereHas('person', fn($q) => $q->where('marga_id', (int)$params['marga_id']));
        if (!empty($params['sub_suku'])) $query->whereHas('person.marga', fn($q) => $q->where('sub_suku', $params['sub_suku']));
        $items = $query->get();
        return $this->jsonResponse($response, ['success' => true, 'data' => $items]);
    }

    public function makamLocations(Request $request, Response $response): Response
    {
        $items = Makam::whereNotNull('latitude')->whereNotNull('longitude')->with('person')->get();
        return $this->jsonResponse($response, ['success' => true, 'data' => $items]);
    }

    public function statistics(Request $request, Response $response): Response
    {
        $locs = PersonLocation::with('person.marga')->get();
        $byCity = [];
        $bySubSuku = [];
        foreach ($locs as $loc) {
            $city = $loc->lokasi ?? 'Unknown';
            $byCity[$city] = ($byCity[$city] ?? 0) + 1;
            $subSuku = $loc->person?->marga?->sub_suku ?? 'Unknown';
            $bySubSuku[$subSuku] = ($bySubSuku[$subSuku] ?? 0) + 1;
        }
        return $this->jsonResponse($response, [
            'success' => true,
            'data' => [
                'by_city' => $byCity,
                'by_sub_suku' => $bySubSuku,
                'total_locations' => $locs->count()
            ]
        ]);
    }

    private function jsonResponse(Response $response, array $data, int $status = 200): Response
    {
        $response->getBody()->write(json_encode($data));
        return $response->withHeader('Content-Type', 'application/json')->withStatus($status);
    }
}
