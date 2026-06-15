<?php
/**
 * Machine Learning Service
 * Handles ML-based predictions for partuturan and family relationships
 * Placeholder for future integration with ML frameworks
 */

namespace App\Services;

use Illuminate\Support\Facades\DB;

class MachineLearningService
{
    /**
     * Predict partuturan relationship between two persons
     * This would use ML models in production
     */
    public function predictPartuturan(int $personId1, int $personId2): array
    {
        // Get person data
        $person1 = DB::table('persons')->where('id', $personId1)->first();
        $person2 = DB::table('persons')->where('id', $personId2)->first();
        
        if (!$person1 || !$person2) {
            return [
                'success' => false,
                'error' => 'One or both persons not found'
            ];
        }
        
        // Rule-based prediction (placeholder for ML)
        $relationship = $this->calculateRelationship($person1, $person2);
        
        return [
            'success' => true,
            'person1' => [
                'id' => $person1->id,
                'name' => $person1->nama
            ],
            'person2' => [
                'id' => $person2->id,
                'name' => $person2->nama
            ],
            'predicted_relationship' => $relationship,
            'confidence' => 0.85,
            'method' => 'rule-based (ML integration pending)',
            'ml_models' => [
                'Random Forest',
                'Neural Network',
                'Graph Neural Networks (GNN)'
            ]
        ];
    }
    
    /**
     * Calculate relationship using rules (placeholder for ML)
     */
    private function calculateRelationship(object $person1, object $person2): array
    {
        // Simple rule-based logic
        // In production, this would use trained ML models
        
        if ($person1->father_id == $person2->id) {
            return ['type' => 'father', 'label' => 'Amang (Ayah)'];
        }
        
        if ($person1->mother_id == $person2->id) {
            return ['type' => 'mother', 'label' => 'Inang (Ibu)'];
        }
        
        if ($person1->marga_id == $person2->marga_id) {
            return ['type' => 'same_marga', 'label' => 'Satu Marga'];
        }
        
        // Check if they are siblings
        if ($person1->father_id == $person2->father_id && $person1->father_id !== null) {
            return ['type' => 'sibling', 'label' => 'Dongan Tubu (Saudara)'];
        }
        
        return ['type' => 'unknown', 'label' => 'Hubungan tidak dikenal'];
    }
    
    /**
     * Predict potential pariban (ideal marriage candidates)
     */
    public function predictPariban(int $personId): array
    {
        $person = DB::table('persons')->where('id', $personId)->first();
        
        if (!$person) {
            return [
                'success' => false,
                'error' => 'Person not found'
            ];
        }
        
        // Get candidates based on marga rules (simplified)
        $candidates = DB::table('persons')
            ->where('id', '!=', $personId)
            ->where('jenis_kelamin', $person->jenis_kelamin === 'L' ? 'P' : 'L')
            ->where('marga_id', '!=', $person->marga_id)
            ->limit(10)
            ->get();
        
        $rankedCandidates = [];
        foreach ($candidates as $candidate) {
            $score = $this->calculateParibanScore($person, $candidate);
            $rankedCandidates[] = [
                'person' => $candidate,
                'score' => $score,
                'confidence' => $score / 100
            ];
        }
        
        // Sort by score
        usort($rankedCandidates, fn($a, $b) => $b['score'] <=> $a['score']);
        
        return [
            'success' => true,
            'person' => $person,
            'candidates' => $rankedCandidates,
            'method' => 'rule-based scoring (ML integration pending)',
            'ml_features' => [
                'marga_distance',
                'geographic_proximity',
                'age_compatibility',
                'family_connections',
                'historical_patterns'
            ]
        ];
    }
    
    /**
     * Calculate pariban score (placeholder for ML)
     */
    private function calculateParibanScore(object $person, object $candidate): float
    {
        $score = 50.0; // Base score
        
        // Rule-based scoring
        // In production, ML would learn optimal weights
        
        // Same sub_suku is good
        $personMarga = DB::table('marga')->where('id', $person->marga_id)->first();
        $candidateMarga = DB::table('marga')->where('id', $candidate->marga_id)->first();
        
        if ($personMarga && $candidateMarga && $personMarga->sub_suku === $candidateMarga->sub_suku) {
            $score += 20;
        }
        
        // Different marga is required
        if ($person->marga_id !== $candidate->marga_id) {
            $score += 15;
        }
        
        return min($score, 100.0);
    }
    
    /**
     * Predict family tree completeness
     */
    public function predictTreeCompleteness(int $rootPersonId): array
    {
        // Get all descendants
        $descendants = $this->getAllDescendants($rootPersonId);
        
        // Calculate completeness metrics
        $totalPersons = DB::table('persons')->count();
        $treePersons = count($descendants);
        
        $completeness = [
            'total_in_tree' => $treePersons,
            'total_in_database' => $totalPersons,
            'coverage_percentage' => $totalPersons > 0 ? ($treePersons / $totalPersons) * 100 : 0,
            'missing_data' => $this->identifyMissingData($descendants),
            'suggestions' => $this->generateTreeSuggestions($descendants)
        ];
        
        return [
            'success' => true,
            'root_person_id' => $rootPersonId,
            'completeness' => $completeness,
            'ml_enhancement' => 'ML can predict missing connections and suggest data collection priorities'
        ];
    }
    
    /**
     * Get all descendants recursively
     */
    private function getAllDescendants(int $personId, array $visited = []): array
    {
        if (in_array($personId, $visited)) {
            return $visited;
        }
        
        $visited[] = $personId;
        
        $children = DB::table('persons')
            ->where('father_id', $personId)
            ->orWhere('mother_id', $personId)
            ->get();
        
        foreach ($children as $child) {
            $visited = $this->getAllDescendants($child->id, $visited);
        }
        
        return $visited;
    }
    
    /**
     * Identify missing data in tree
     */
    private function identifyMissingData(array $personIds): array
    {
        $missing = [];
        
        foreach ($personIds as $id) {
            $person = DB::table('persons')->where('id', $id)->first();
            
            if (!$person->father_id && !$person->mother_id) {
                $missing[] = [
                    'person_id' => $id,
                    'missing' => 'parents',
                    'name' => $person->nama
                ];
            }
            
            if (!$person->tanggal_lahir) {
                $missing[] = [
                    'person_id' => $id,
                    'missing' => 'birth_date',
                    'name' => $person->nama
                ];
            }
        }
        
        return $missing;
    }
    
    /**
     * Generate tree improvement suggestions
     */
    private function generateTreeSuggestions(array $personIds): array
    {
        return [
            'Collect missing parent information',
            'Add birth dates and locations',
            'Document marriage records',
            'Record death dates for deceased',
            'Add photos and documents',
            'Verify marga information'
        ];
    }
    
    /**
     * Train ML model (placeholder)
     */
    public function trainModel(string $modelType, array $trainingData): array
    {
        return [
            'success' => false,
            'message' => 'ML training integration pending',
            'model_type' => $modelType,
            'data_size' => count($trainingData),
            'required_frameworks' => [
                'TensorFlow',
                'PyTorch',
                'Scikit-learn',
                'XGBoost'
            ]
        ];
    }
}
