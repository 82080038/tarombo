<?php
/**
 * Backup Controller
 * Handles data export and import for backup purposes
 */

namespace App\Controllers;

use Illuminate\Support\Facades\DB;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;

class BackupController
{
    /**
     * Export all data as JSON
     */
    public function export(Request $request, Response $response): Response
    {
        try {
            $tables = [
                'marga',
                'persons',
                'marriages',
                'assets',
                'inheritance_records',
                'transactions',
                'budgets',
                'iuran',
                'oral_traditions',
                'traditional_knowledge',
                'cultural_sites',
                'entity_history',
                'entity_timeline',
                'entity_version',
                'punguan',
                'documents',
                'makam',
                'tanah_ulayat',
                'events',
                'notifications'
            ];
            
            $backupData = [];
            
            foreach ($tables as $table) {
                try {
                    $data = DB::table($table)->get()->toArray();
                    $backupData[$table] = $data;
                } catch (\Exception $e) {
                    // Skip tables that don't exist or have errors
                    $backupData[$table] = [];
                }
            }
            
            $backup = [
                'version' => '1.0',
                'exported_at' => now()->toIso8601String(),
                'exported_by' => $request->getAttribute('user_id'),
                'data' => $backupData
            ];
        
            $filename = 'tarombo_backup_' . date('Y-m-d_His') . '.json';
            
            $response->getBody()->write(json_encode($backup, JSON_PRETTY_PRINT));
            return $response
                ->withHeader('Content-Type', 'application/json')
                ->withHeader('Content-Disposition', 'attachment; filename="' . $filename . '"');
        } catch (\Exception $e) {
            $response->getBody()->write(json_encode([
                'success' => false,
                'error' => 'Failed to export backup: ' . $e->getMessage()
            ]));
            return $response->withStatus(500);
        }
    }
    
    /**
     * Export specific entity type
     */
    public function exportEntity(Request $request, Response $response, array $args): Response
    {
        $entityType = $args['type'];
        
        try {
            $data = DB::table($entityType)->get()->toArray();
            
            $backup = [
                'version' => '1.0',
                'exported_at' => now()->toIso8601String(),
                'exported_by' => $request->getAttribute('user_id'),
                'entity_type' => $entityType,
                'data' => $data
            ];
            
            $filename = 'tarombo_' . $entityType . '_' . date('Y-m-d_His') . '.json';
            
            $response->getBody()->write(json_encode($backup, JSON_PRETTY_PRINT));
            return $response
                ->withHeader('Content-Type', 'application/json')
                ->withHeader('Content-Disposition', 'attachment; filename="' . $filename . '"');
        } catch (\Exception $e) {
            $response->getBody()->write(json_encode([
                'success' => false,
                'error' => 'Failed to export entity: ' . $e->getMessage()
            ]));
            return $response->withStatus(500);
        }
    }
    
    /**
     * Import data from JSON backup
     */
    public function import(Request $request, Response $response): Response
    {
        $files = $request->getUploadedFiles();
        
        if (!isset($files['backup'])) {
            return $this->jsonResponse($response, [
                'success' => false,
                'error' => 'No backup file provided'
            ], 400);
        }
        
        $file = $files['backup'];
        $content = $file->getStream()->getContents();
        
        try {
            $backup = json_decode($content, true);
            
            if (!$backup || !isset($backup['data'])) {
                return $this->jsonResponse($response, [
                    'success' => false,
                    'error' => 'Invalid backup file format'
                ], 400);
            }
            
            $imported = [];
            $errors = [];
            
            foreach ($backup['data'] as $table => $rows) {
                try {
                    if (empty($rows)) {
                        continue;
                    }
                    
                    DB::table($table)->truncate();
                    
                    foreach ($rows as $row) {
                        // Remove auto-increment ID to avoid conflicts
                        unset($row['id']);
                        DB::table($table)->insert($row);
                    }
                    
                    $imported[] = $table;
                } catch (\Exception $e) {
                    $errors[] = [
                        'table' => $table,
                        'error' => $e->getMessage()
                    ];
                }
            }
            
            return $this->jsonResponse($response, [
                'success' => true,
                'imported_tables' => $imported,
                'errors' => $errors,
                'backup_version' => $backup['version'] ?? 'unknown',
                'backup_date' => $backup['exported_at'] ?? 'unknown'
            ]);
        } catch (\Exception $e) {
            return $this->jsonResponse($response, [
                'success' => false,
                'error' => 'Failed to import backup: ' . $e->getMessage()
            ], 500);
        }
    }
    
    /**
     * Get backup history
     */
    public function getBackupHistory(Request $request, Response $response): Response
    {
        // For now, return entity history as backup history
        // In production, this should query a dedicated backups table
        $history = DB::table('entity_history')
            ->where('action', 'created')
            ->orderBy('changed_at', 'desc')
            ->limit(50)
            ->get();
        
        return $this->jsonResponse($response, [
            'success' => true,
            'data' => $history
        ]);
    }
    
    private function jsonResponse(Response $response, array $data, int $status = 200): Response
    {
        $response->getBody()->write(json_encode($data));
        return $response
            ->withHeader('Content-Type', 'application/json')
            ->withStatus($status);
    }
}
