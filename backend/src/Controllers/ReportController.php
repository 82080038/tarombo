<?php
/**
 * Report Controller
 * Handles export/import of reports (PDF, Excel, CSV)
 */

namespace App\Controllers;

use PhpOffice\PhpSpreadsheet\Spreadsheet;
use PhpOffice\PhpSpreadsheet\Writer\Xlsx;
use PhpOffice\PhpSpreadsheet\Writer\Csv;
use Mpdf\Mpdf;
use App\Models\Person;
use App\Models\Marriage;
use App\Models\Marga;
use App\Models\Punguan;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;

class ReportController
{
    /**
     * Export persons to Excel
     */
    public function exportPersonsExcel(Request $request, Response $response): Response
    {
        $spreadsheet = new Spreadsheet();
        $sheet = $spreadsheet->getActiveSheet();
        
        // Set headers
        $sheet->setCellValue('A1', 'ID');
        $sheet->setCellValue('B1', 'Nama');
        $sheet->setCellValue('C1', 'Marga');
        $sheet->setCellValue('D1', 'Jenis Kelamin');
        $sheet->setCellValue('E1', 'Tanggal Lahir');
        $sheet->setCellValue('F1', 'Tempat Lahir');
        $sheet->setCellValue('G1', 'Tanggal Meninggal');
        $sheet->setCellValue('H1', 'Status');
        
        // Get data
        $persons = Person::with('marga')->get();
        $row = 2;
        
        foreach ($persons as $person) {
            $sheet->setCellValue('A' . $row, $person->id);
            $sheet->setCellValue('B' . $row, $person->nama);
            $sheet->setCellValue('C' . $row, $person->marga->nama ?? '');
            $sheet->setCellValue('D' . $row, $person->jenis_kelamin === 'L' ? 'Laki-laki' : 'Perempuan');
            $sheet->setCellValue('E' . $row, $person->tanggal_lahir ?? '');
            $sheet->setCellValue('F' . $row, $person->tempat_lahir ?? '');
            $sheet->setCellValue('G' . $row, $person->tanggal_meninggal ?? '');
            $sheet->setCellValue('H' . $row, $person->status);
            $row++;
        }
        
        // Style header
        $sheet->getStyle('A1:H1')->getFont()->setBold(true);
        $sheet->getStyle('A1:H1')->getFill()->setFillType(\PhpOffice\PhpSpreadsheet\Style\Fill::FILL_SOLID)->getStartColor()->setARGB('FFCCCCCC');
        
        // Auto size columns
        foreach (range('A', 'H') as $col) {
            $sheet->getColumnDimension($col)->setAutoSize(true);
        }
        
        // Write file
        $writer = new Xlsx($spreadsheet);
        $filename = 'persons_' . date('Y-m-d_His') . '.xlsx';
        $tempFile = sys_get_temp_dir() . '/' . $filename;
        $writer->save($tempFile);
        
        // Send file
        $fileContent = file_get_contents($tempFile);
        unlink($tempFile);
        
        $response->getBody()->write($fileContent);
        return $response
            ->withHeader('Content-Type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
            ->withHeader('Content-Disposition', 'attachment; filename="' . $filename . '"');
    }
    
    /**
     * Export persons to CSV
     */
    public function exportPersonsCsv(Request $request, Response $response): Response
    {
        $spreadsheet = new Spreadsheet();
        $sheet = $spreadsheet->getActiveSheet();
        
        // Set headers
        $sheet->setCellValue('A1', 'ID');
        $sheet->setCellValue('B1', 'Nama');
        $sheet->setCellValue('C1', 'Marga');
        $sheet->setCellValue('D1', 'Jenis Kelamin');
        $sheet->setCellValue('E1', 'Tanggal Lahir');
        $sheet->setCellValue('F1', 'Tempat Lahir');
        $sheet->setCellValue('G1', 'Tanggal Meninggal');
        $sheet->setCellValue('H1', 'Status');
        
        // Get data
        $persons = Person::with('marga')->get();
        $row = 2;
        
        foreach ($persons as $person) {
            $sheet->setCellValue('A' . $row, $person->id);
            $sheet->setCellValue('B' . $row, $person->nama);
            $sheet->setCellValue('C' . $row, $person->marga->nama ?? '');
            $sheet->setCellValue('D' . $row, $person->jenis_kelamin === 'L' ? 'Laki-laki' : 'Perempuan');
            $sheet->setCellValue('E' . $row, $person->tanggal_lahir ?? '');
            $sheet->setCellValue('F' . $row, $person->tempat_lahir ?? '');
            $sheet->setCellValue('G' . $row, $person->tanggal_meninggal ?? '');
            $sheet->setCellValue('H' . $row, $person->status);
            $row++;
        }
        
        // Write file
        $writer = new Csv($spreadsheet);
        $filename = 'persons_' . date('Y-m-d_His') . '.csv';
        $tempFile = sys_get_temp_dir() . '/' . $filename;
        $writer->save($tempFile);
        
        // Send file
        $fileContent = file_get_contents($tempFile);
        unlink($tempFile);
        
        $response->getBody()->write($fileContent);
        return $response
            ->withHeader('Content-Type', 'text/csv')
            ->withHeader('Content-Disposition', 'attachment; filename="' . $filename . '"');
    }
    
    /**
     * Export family tree to PDF
     */
    public function exportFamilyTreePdf(Request $request, Response $response): Response
    {
        $mpdf = new Mpdf();
        
        // Get data
        $persons = Person::with('marga', 'father', 'mother')->where('status', 'active')->get();
        
        // Build HTML
        $html = '<h1>Family Tree - Tarombo Digital</h1>';
        $html .= '<p>Generated on: ' . date('Y-m-d H:i:s') . '</p>';
        $html .= '<table border="1" cellpadding="5" style="width:100%; border-collapse:collapse;">';
        $html .= '<thead><tr><th>ID</th><th>Nama</th><th>Marga</th><th>Jenis Kelamin</th><th>Ayah</th><th>Ibu</th></tr></thead>';
        $html .= '<tbody>';
        
        foreach ($persons as $person) {
            $html .= '<tr>';
            $html .= '<td>' . $person->id . '</td>';
            $html .= '<td>' . htmlspecialchars($person->nama) . '</td>';
            $html .= '<td>' . htmlspecialchars($person->marga->nama ?? '') . '</td>';
            $html .= '<td>' . ($person->jenis_kelamin === 'L' ? 'Laki-laki' : 'Perempuan') . '</td>';
            $html .= '<td>' . htmlspecialchars($person->father->nama ?? '-') . '</td>';
            $html .= '<td>' . htmlspecialchars($person->mother->nama ?? '-') . '</td>';
            $html .= '</tr>';
        }
        
        $html .= '</tbody></table>';
        
        $mpdf->WriteHTML($html);
        
        $filename = 'family_tree_' . date('Y-m-d_His') . '.pdf';
        $output = $mpdf->Output('', 'S');
        
        $response->getBody()->write($output);
        return $response
            ->withHeader('Content-Type', 'application/pdf')
            ->withHeader('Content-Disposition', 'attachment; filename="' . $filename . '"');
    }
    
    /**
     * Export marriages to Excel
     */
    public function exportMarriagesExcel(Request $request, Response $response): Response
    {
        $spreadsheet = new Spreadsheet();
        $sheet = $spreadsheet->getActiveSheet();
        
        // Set headers
        $sheet->setCellValue('A1', 'ID');
        $sheet->setCellValue('B1', 'Suami');
        $sheet->setCellValue('C1', 'Istri');
        $sheet->setCellValue('D1', 'Tanggal Perkawinan');
        $sheet->setCellValue('E1', 'Tempat Perkawinan');
        $sheet->setCellValue('F1', 'Hula-Hula Marga');
        $sheet->setCellValue('G1', 'Boru Marga');
        $sheet->setCellValue('H1', 'Status');
        
        // Get data
        $marriages = Marriage::with(['husband', 'wife', 'hulaHulaMarga', 'boruMarga'])->get();
        $row = 2;
        
        foreach ($marriages as $marriage) {
            $sheet->setCellValue('A' . $row, $marriage->id);
            $sheet->setCellValue('B' . $row, $marriage->husband->nama ?? '');
            $sheet->setCellValue('C' . $row, $marriage->wife->nama ?? '');
            $sheet->setCellValue('D' . $row, $marriage->tanggal_perkawinan ?? '');
            $sheet->setCellValue('E' . $row, $marriage->tempat_perkawinan ?? '');
            $sheet->setCellValue('F' . $row, $marriage->hulaHulaMarga->nama ?? '');
            $sheet->setCellValue('G' . $row, $marriage->boruMarga->nama ?? '');
            $sheet->setCellValue('H' . $row, $marriage->status);
            $row++;
        }
        
        // Style header
        $sheet->getStyle('A1:H1')->getFont()->setBold(true);
        $sheet->getStyle('A1:H1')->getFill()->setFillType(\PhpOffice\PhpSpreadsheet\Style\Fill::FILL_SOLID)->getStartColor()->setARGB('FFCCCCCC');
        
        // Auto size columns
        foreach (range('A', 'H') as $col) {
            $sheet->getColumnDimension($col)->setAutoSize(true);
        }
        
        // Write file
        $writer = new Xlsx($spreadsheet);
        $filename = 'marriages_' . date('Y-m-d_His') . '.xlsx';
        $tempFile = sys_get_temp_dir() . '/' . $filename;
        $writer->save($tempFile);
        
        // Send file
        $fileContent = file_get_contents($tempFile);
        unlink($tempFile);
        
        $response->getBody()->write($fileContent);
        return $response
            ->withHeader('Content-Type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
            ->withHeader('Content-Disposition', 'attachment; filename="' . $filename . '"');
    }
    
    /**
     * Export statistics to PDF
     */
    public function exportStatisticsPdf(Request $request, Response $response): Response
    {
        $mpdf = new Mpdf();
        
        // Get statistics
        $totalPersons = Person::where('status', 'active')->count();
        $totalMarriages = Marriage::where('status', 'active')->count();
        $totalMarga = Marga::where('status', 'active')->count();
        $totalPunguan = Punguan::where('status', 'active')->count();
        
        $maleCount = Person::where('status', 'active')->where('jenis_kelamin', 'L')->count();
        $femaleCount = Person::where('status', 'active')->where('jenis_kelamin', 'P')->count();
        
        // Build HTML
        $html = '<h1>Statistics Report - Tarombo Digital</h1>';
        $html .= '<p>Generated on: ' . date('Y-m-d H:i:s') . '</p>';
        $html .= '<h2>Overview</h2>';
        $html .= '<table border="1" cellpadding="5" style="width:50%; border-collapse:collapse;">';
        $html .= '<tr><th>Metric</th><th>Count</th></tr>';
        $html .= '<tr><td>Total Persons</td><td>' . $totalPersons . '</td></tr>';
        $html .= '<tr><td>Total Marriages</td><td>' . $totalMarriages . '</td></tr>';
        $html .= '<tr><td>Total Marga</td><td>' . $totalMarga . '</td></tr>';
        $html .= '<tr><td>Total Punguan</td><td>' . $totalPunguan . '</td></tr>';
        $html .= '<tr><td>Male</td><td>' . $maleCount . '</td></tr>';
        $html .= '<tr><td>Female</td><td>' . $femaleCount . '</td></tr>';
        $html .= '</table>';
        
        $mpdf->WriteHTML($html);
        
        $filename = 'statistics_' . date('Y-m-d_His') . '.pdf';
        $output = $mpdf->Output('', 'S');
        
        $response->getBody()->write($output);
        return $response
            ->withHeader('Content-Type', 'application/pdf')
            ->withHeader('Content-Disposition', 'attachment; filename="' . $filename . '"');
    }
}
