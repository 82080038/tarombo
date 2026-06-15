<?php
/**
 * Transliteration Service
 * Handles Batak language transliteration and basic AI-assisted translation
 */

namespace App\Services;

class TransliterationService
{
    /**
     * Basic Batak to Latin transliteration mapping
     * This is a simplified version - can be enhanced with ML models
     */
    private array $batakToLatinMap = [
        // Vowels
        'ᯀ' => 'a',
        'ᯁ' => 'i',
        'ᯂ' => 'u',
        'ᯃ' => 'e',
        'ᯄ' => 'o',
        // Consonants (simplified mapping)
        'ᯅ' => 'b',
        'ᯆ' => 'c',
        'ᯇ' => 'd',
        'ᯈ' => 'g',
        'ᯉ' => 'h',
        'ᯊ' => 'j',
        'ᯋ' => 'k',
        'ᯌ' => 'l',
        'ᯍ' => 'm',
        'ᯎ' => 'n',
        'ᯏ' => 'p',
        'ᯐ' => 'r',
        'ᯑ' => 's',
        'ᯒ' => 't',
        'ᯓ' => 'w',
        'ᯔ' => 'y',
        'ᯕ' => 'ng',
        'ᯖ' => 'ny',
    ];
    
    /**
     * Transliterate Batak script to Latin
     */
    public function batakToLatin(string $batakText): string
    {
        $latinText = '';
        $chars = mb_str_split($batakText);
        
        foreach ($chars as $char) {
            if (isset($this->batakToLatinMap[$char])) {
                $latinText .= $this->batakToLatinMap[$char];
            } else {
                $latinText .= $char;
            }
        }
        
        return $latinText;
    }
    
    /**
     * Basic Latin to Batak transliteration
     */
    public function latinToBatak(string $latinText): string
    {
        $batakText = '';
        $latinText = strtolower($latinText);
        
        // Simple phonetic mapping (can be improved)
        $replacements = [
            'ng' => 'ᯕ',
            'ny' => 'ᯖ',
            'a' => 'ᯀ',
            'i' => 'ᯁ',
            'u' => 'ᯂ',
            'e' => 'ᯃ',
            'o' => 'ᯄ',
            'b' => 'ᯅ',
            'c' => 'ᯆ',
            'd' => 'ᯇ',
            'g' => 'ᯈ',
            'h' => 'ᯉ',
            'j' => 'ᯊ',
            'k' => 'ᯋ',
            'l' => 'ᯌ',
            'm' => 'ᯍ',
            'n' => 'ᯎ',
            'p' => 'ᯏ',
            'r' => 'ᯐ',
            's' => 'ᯑ',
            't' => 'ᯒ',
            'w' => 'ᯓ',
            'y' => 'ᯔ',
        ];
        
        // Handle digraphs first
        $batakText = str_replace(['ng', 'ny'], ['ᯕ', 'ᯖ'], $latinText);
        
        // Then handle single characters
        foreach ($replacements as $latin => $batak) {
            if (strlen($latin) === 1) {
                $batakText = str_replace($latin, $batak, $batakText);
            }
        }
        
        return $batakText;
    }
    
    /**
     * Basic Batak to Indonesian translation
     * This is a placeholder - in production, integrate with translation API
     */
    public function translateToIndonesian(string $batakText): array
    {
        // Dictionary-based translation for common words
        $dictionary = [
            'horas' => 'halo/salam',
            'mejuah-juah' => 'selamat',
            'ulos' => 'kain ulos',
            'tunggal panaluan' => 'satu tujuan',
            'sahat' => 'baik',
            'namo' => 'rumah',
            'huta' => 'desa',
            'marga' => 'marga/clan',
            'tarombo' => 'silsilah',
            'partuturan' => 'hubungan kekerabatan',
            'dongan' => 'teman',
            'tubu' => 'lahir',
            'amang' => 'ayah',
            'inang' => 'ibu',
            'boru' => 'anak perempuan',
            'tulang' => 'saudara laki-laki ibu',
            'namboru' => 'saudara perempuan ayah',
            'bere' => 'anak dari saudara perempuan',
            'pariban' => 'calon pasangan ideal',
            'punguan' => 'organisasi marga',
            'adat' => 'adat istiadat',
            'somba' => 'hormat',
            'manat' => 'adil',
            'martula-tula' => 'saling melengkapi',
        ];
        
        $words = preg_split('/\s+/', strtolower($batakText));
        $translated = [];
        $unknown = [];
        
        foreach ($words as $word) {
            $cleanWord = preg_replace('/[^\p{L}]/u', '', $word);
            if (isset($dictionary[$cleanWord])) {
                $translated[] = [
                    'original' => $word,
                    'translation' => $dictionary[$cleanWord]
                ];
            } else {
                $unknown[] = $word;
            }
        }
        
        return [
            'original' => $batakText,
            'translated_words' => $translated,
            'unknown_words' => $unknown,
            'full_translation' => implode(' ', array_column($translated, 'translation'))
        ];
    }
    
    /**
     * Get transliteration suggestions using AI
     * Placeholder for future AI integration
     */
    public function getTransliterationSuggestions(string $text): array
    {
        // This would integrate with an AI service in production
        // For now, return basic suggestions
        
        return [
            'suggestions' => [
                [
                    'type' => 'transliteration',
                    'original' => $text,
                    'suggested' => $this->batakToLatin($text),
                    'confidence' => 0.8
                ],
                [
                    'type' => 'translation',
                    'original' => $text,
                    'suggested' => $this->translateToIndonesian($text)['full_translation'],
                    'confidence' => 0.6
                ]
            ],
            'note' => 'AI integration pending - using rule-based transliteration'
        ];
    }
    
    /**
     * Validate Batak text structure
     */
    public function validateBatakText(string $text): array
    {
        $hasBatakChars = preg_match('/[\x{1BC0}-\x{1BFF}]/u', $text);
        $hasLatinChars = preg_match('/[a-zA-Z]/u', $text);
        
        return [
            'has_batak_script' => $hasBatakChars,
            'has_latin_script' => $hasLatinChars,
            'is_mixed' => $hasBatakChars && $hasLatinChars,
            'suggested_action' => $hasBatakChars ? 'Can transliterate to Latin' : 'No Batak script detected'
        ];
    }
}
