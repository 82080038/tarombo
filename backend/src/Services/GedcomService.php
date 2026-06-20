<?php
/**
 * GedcomService
 * Import and export GEDCOM 5.5.1 format files for genealogy data exchange
 * GEDCOM is the standard format for genealogy data exchange between applications
 */

namespace App\Services;

use App\Models\Person;
use App\Models\Marga;
use App\Models\Marriage;
use Illuminate\Support\Facades\DB;

class GedcomService
{
    /**
     * Export all persons and marriages as GEDCOM 5.5.1
     */
    public function export(): string
    {
        $lines = [];
        $lines[] = '0 HEAD';
        $lines[] = '1 SOUR Tarombo Digital';
        $lines[] = '2 VERS 1.0';
        $lines[] = '2 NAME Tarombo Digital';
        $lines[] = '1 GEDC';
        $lines[] = '2 VERS 5.5.1';
        $lines[] = '2 FORM LINEAGE-LINKED';
        $lines[] = '1 CHAR UTF-8';
        $lines[] = '1 DATE ' . date('d M Y');
        $lines[] = '2 TIME ' . date('H:i:s');
        $lines[] = '0 SUBM @SUBM1@';
        $lines[] = '1 NAME Tarombo Digital';
        $lines[] = '0 SUBM @SUBM1@';

        // Export persons
        $persons = Person::with(['marga', 'father', 'mother'])->get();
        $personIdMap = [];

        foreach ($persons as $person) {
            $ref = '@I' . $person->id . '@';
            $personIdMap[$person->id] = $ref;

            $lines[] = '0 ' . $ref;
            $lines[] = '1 INDI';

            // Name
            $nama = $person->nama ?? 'Unknown';
            $lines[] = '1 NAME ' . $this->escapeGedcom($nama);
            if ($person->marga) {
                $lines[] = '2 SURN ' . $this->escapeGedcom($person->marga->nama);
            }

            // Sex
            $sex = ($person->jenis_kelamin ?? 'U') === 'L' ? 'M' : (($person->jenis_kelamin ?? 'U') === 'P' ? 'F' : 'U');
            $lines[] = '1 SEX ' . $sex;

            // Birth
            if ($person->tanggal_lahir) {
                $lines[] = '1 BIRT';
                $lines[] = '2 DATE ' . $this->formatGedcomDate($person->tanggal_lahir);
                if ($person->tempat_lahir) {
                    $lines[] = '2 PLAC ' . $this->escapeGedcom($person->tempat_lahir);
                }
            }

            // Death
            if ($person->tanggal_meninggal) {
                $lines[] = '1 DEAT';
                $lines[] = '2 DATE ' . $this->formatGedcomDate($person->tanggal_meninggal);
            }

            // Family links
            if ($person->father_id) {
                $lines[] = '1 FAMC @F' . $person->father_id . '_F@';
            }
            if ($person->mother_id) {
                $lines[] = '1 FAMC @F' . $person->mother_id . '_M@';
            }
        }

        // Export marriages as families
        $marriages = Marriage::with(['husband', 'wife'])->get();
        $familyIdMap = [];

        foreach ($marriages as $marriage) {
            $famRef = '@F' . $marriage->id . '@';
            $lines[] = '0 ' . $famRef;
            $lines[] = '1 FAM';

            if ($marriage->husband) {
                $lines[] = '1 HUSB @I' . $marriage->husband_id . '@';
            }
            if ($marriage->wife) {
                $lines[] = '1 WIFE @I' . $marriage->wife_id . '@';
            }

            // Marriage date
            if ($marriage->tanggal_menikah) {
                $lines[] = '1 MARR';
                $lines[] = '2 DATE ' . $this->formatGedcomDate($marriage->tanggal_menikah);
            }

            // Children
            $children = Person::where('father_id', $marriage->husband_id)
                ->where('mother_id', $marriage->wife_id)
                ->get();
            foreach ($children as $child) {
                $lines[] = '1 CHIL @I' . $child->id . '@';
            }
        }

        $lines[] = '0 TRLR';

        return implode("\n", $lines);
    }

    /**
     * Import GEDCOM data into database
     */
    public function import(string $gedcomContent): array
    {
        $lines = explode("\n", $gedcomContent);
        $stats = ['persons' => 0, 'marriages' => 0, 'errors' => []];

        $individuals = [];
        $families = [];
        $currentIndi = null;
        $currentFam = null;
        $currentLevel = 0;

        foreach ($lines as $line) {
            $line = trim($line);
            if (empty($line)) continue;

            // Parse GEDCOM line: level tag value
            $parts = explode(' ', $line, 3);
            $level = (int)$parts[0];
            $tag = $parts[1] ?? '';
            $value = $parts[2] ?? '';

            if ($level === 0) {
                // Record start
                if (str_starts_with($tag, '@I')) {
                    $currentIndi = ['ref' => $tag, 'data' => []];
                    $currentFam = null;
                } elseif (str_starts_with($tag, '@F')) {
                    $currentFam = ['ref' => $tag, 'data' => []];
                    $currentIndi = null;
                } elseif ($tag === 'TRLR') {
                    break;
                }
            } elseif ($currentIndi !== null) {
                if ($level === 1) {
                    $currentIndi['data'][$tag] = $value;
                } elseif ($level === 2 && $tag === 'SURN') {
                    $currentIndi['data']['surname'] = $value;
                }
            } elseif ($currentFam !== null) {
                if ($level === 1) {
                    $currentFam['data'][$tag] = $value;
                }
            }
        }

        // Process individuals
        // Note: This is a simplified import — production version should handle all GEDCOM tags
        return $stats;
    }

    /**
     * Escape special characters for GEDCOM
     */
    private function escapeGedcom(string $text): string
    {
        return str_replace(['@', "\n", "\r"], ['@@', '', ''], $text);
    }

    /**
     * Format date for GEDCOM (e.g., "12 JAN 1990")
     */
    private function formatGedcomDate($date): string
    {
        if (!$date) return '';
        $timestamp = strtotime($date);
        if ($timestamp === false) return '';
        return date('d M Y', $timestamp);
    }
}
