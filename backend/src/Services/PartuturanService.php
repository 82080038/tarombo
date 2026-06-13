<?php
/**
 * Partuturan Service
 * Calculates relationship terms between persons
 */

namespace App\Services;

use App\Models\Person;

class PartuturanService
{
    /**
     * Calculate relationship between two persons
     */
    public function calculate(Person $from, Person $to): PartuturanResult
    {
        // Find path using BFS
        $path = $this->findShortestPath($from, $to);
        
        if (empty($path)) {
            return new PartuturanResult(
                term: 'Tidak diketahui',
                indonesian: 'Hubungan tidak ditemukan',
                path: [],
                explanation: 'Tidak ada jalur kekerabatan yang ditemukan'
            );
        }
        
        // Analyze path pattern
        $pattern = $this->analyzePathPattern($path);
        
        // Map to partuturan term
        return $this->mapToPartuturan($pattern, $path, $from, $to);
    }
    
    /**
     * Find shortest path between two persons using BFS
     */
    private function findShortestPath(Person $from, Person $to): array
    {
        if ($from->id === $to->id) {
            return [$from];
        }
        
        $queue = [[$from, [$from]]];
        $visited = [$from->id => true];
        
        while (!empty($queue)) {
            [$current, $path] = array_shift($queue);
            
            // Get all relations
            $relations = [];
            
            if ($current->father) {
                $relations[] = $current->father;
            }
            if ($current->mother) {
                $relations[] = $current->mother;
            }
            foreach ($current->childrenAsFather as $child) {
                $relations[] = $child;
            }
            foreach ($current->childrenAsMother as $child) {
                $relations[] = $child;
            }
            foreach ($current->marriagesAsHusband as $marriage) {
                $relations[] = $marriage->wife;
            }
            foreach ($current->marriagesAsWife as $marriage) {
                $relations[] = $marriage->husband;
            }
            
            foreach ($relations as $next) {
                if (!isset($visited[$next->id])) {
                    if ($next->id === $to->id) {
                        return array_merge($path, [$next]);
                    }
                    
                    $visited[$next->id] = true;
                    $queue[] = [$next, array_merge($path, [$next])];
                }
            }
        }
        
        return [];
    }
    
    /**
     * Analyze path pattern
     */
    private function analyzePathPattern(array $path): string
    {
        $n = count($path);
        if ($n < 2) {
            return 'self';
        }
        
        $from = $path[0];
        $to = $path[$n - 1];
        
        // Direct parent-child
        if ($n === 2) {
            if ($to->id === $from->father_id || $to->id === $from->mother_id) {
                return $to->jenis_kelamin === 'L' ? 'father' : 'mother';
            }
            if ($from->id === $to->father_id || $from->id === $to->mother_id) {
                return $from->jenis_kelamin === 'L' ? 'son' : 'daughter';
            }
            // Spouse
            return 'spouse';
        }
        
        // Siblings (through common parent) - check before grandparent
        if ($n === 3) {
            $middle = $path[1];
            if (($middle->id === $from->father_id && $middle->id === $to->father_id) ||
                ($middle->id === $from->mother_id && $middle->id === $to->mother_id)) {
                return $to->jenis_kelamin === 'L' ? 'brother' : 'sister';
            }
        }
        
        // Grandparents (3 levels)
        if ($n === 3) {
            return 'grandparent';
        }
        
        // Extended family patterns
        return 'extended';
    }
    
    /**
     * Map pattern to partuturan term
     */
    private function mapToPartuturan(string $pattern, array $path, Person $from, Person $to): PartuturanResult
    {
        $term = match($pattern) {
            'self' => 'Diri sendiri',
            'father' => 'Bapak',
            'mother' => 'Mama',
            'son' => 'Anak laki-laki',
            'daughter' => 'Anak perempuan',
            'spouse' => 'Suami/Istri',
            'brother' => 'Dongan saur',
            'sister' => 'Dongan saur',
            'grandparent' => $to->jenis_kelamin === 'L' ? 'Ama' : 'Ina',
            default => $this->calculateExtendedRelationship($path, $from, $to),
        };
        
        $indonesian = match($pattern) {
            'self' => 'Diri sendiri',
            'father' => 'Ayah',
            'mother' => 'Ibu',
            'son' => 'Anak laki-laki',
            'daughter' => 'Anak perempuan',
            'spouse' => 'Pasangan',
            'brother' => 'Saudara laki-laki',
            'sister' => 'Saudara perempuan',
            'grandparent' => $to->jenis_kelamin === 'L' ? 'Kakek' : 'Nenek',
            default => 'Keluarga jauh',
        };
        
        $pathDescription = $this->generatePathDescription($path);
        
        return new PartuturanResult(
            term: $term,
            indonesian: $indonesian,
            path: array_map(fn($p) => ['id' => $p->id, 'nama' => $p->nama], $path),
            explanation: $pathDescription
        );
    }
    
    /**
     * Calculate extended relationships
     */
    private function calculateExtendedRelationship(array $path, Person $from, Person $to): string
    {
        $n = count($path);
        
        // Tulang (mother's brother)
        if ($this->isTulang($path)) {
            return 'Tulang';
        }
        
        // Namboru (father's sister)
        if ($this->isNamboru($path)) {
            return 'Namboru';
        }
        
        // Bere (sister's child)
        if ($this->isBere($path)) {
            return $to->jenis_kelamin === 'L' ? 'Bere' : 'Bere boru';
        }
        
        // Cousins (anak dari dongan saur)
        if ($n === 4 && $this->isCousin($path)) {
            return $to->jenis_kelamin === 'L' ? 'Parumaen' : 'Tubuan';
        }
        
        // Default - calculate generation gap
        return 'Kelasi (' . ($n - 1) . ' tingkat)';
    }
    
    private function isTulang(array $path): bool
    {
        // Path: Person -> Mother -> Mother's Brother
        if (count($path) !== 3) return false;
        
        $person = $path[0];
        $middle = $path[1];
        $target = $path[2];
        
        return $middle->id === $person->mother_id && 
               $target->jenis_kelamin === 'L';
    }
    
    private function isNamboru(array $path): bool
    {
        // Path: Person -> Father -> Father's Sister
        if (count($path) !== 3) return false;
        
        $person = $path[0];
        $middle = $path[1];
        $target = $path[2];
        
        return $middle->id === $person->father_id && 
               $target->jenis_kelamin === 'P';
    }
    
    private function isBere(array $path): bool
    {
        // Path: Person -> Sister -> Sister's Child
        if (count($path) !== 3) return false;
        
        $person = $path[0];
        $middle = $path[1];
        
        // Check if middle is sister (same parents, female)
        $isSister = ($middle->father_id === $person->father_id ||
                     $middle->mother_id === $person->mother_id) &&
                    $middle->jenis_kelamin === 'P';
        
        return $isSister;
    }
    
    private function isCousin(array $path): bool
    {
        // Path: Person -> Parent -> Parent's Sibling -> Sibling's Child
        if (count($path) !== 4) return false;
        
        // Simplified check - actual implementation would verify relationships
        return true;
    }
    
    private function generatePathDescription(array $path): string
    {
        $steps = [];
        for ($i = 0; $i < count($path) - 1; $i++) {
            $from = $path[$i];
            $to = $path[$i + 1];
            
            if ($to->id === $from->father_id) {
                $steps[] = "Ayah dari {$from->nama}";
            } elseif ($to->id === $from->mother_id) {
                $steps[] = "Ibu dari {$from->nama}";
            } elseif ($from->id === $to->father_id || $from->id === $to->mother_id) {
                $steps[] = "Anak dari {$from->nama}";
            } else {
                $steps[] = "→ {$to->nama}";
            }
        }
        
        return implode(' → ', $steps);
    }
}

/**
 * Partuturan Result Data Transfer Object
 */
class PartuturanResult
{
    public function __construct(
        public string $term,
        public string $indonesian,
        public array $path,
        public string $explanation
    ) {}
}
