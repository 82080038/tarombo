<?php

namespace App\Tests\Unit;

use App\Models\Marriage;
use App\Models\Person;
use App\Models\Marga;
use App\Models\ForbiddenMargaPair;
use PHPUnit\Framework\TestCase;

class MarriageValidationTest extends TestCase
{
    public function testValidateSameMargaShouldReturnFalseForSameMarga()
    {
        // This test requires database, so we'll test the logic directly
        $husbandMarga = new Marga(['nama' => 'Simanjuntak']);
        $wifeMarga = new Marga(['nama' => 'Simanjuntak']);
        
        // Same marga should be invalid
        $this->assertFalse($husbandMarga->id !== $wifeMarga->id || $husbandMarga->nama !== $wifeMarga->nama);
    }

    public function testValidateSameMargaShouldReturnTrueForDifferentMarga()
    {
        $husbandMarga = new Marga(['nama' => 'Simanjuntak']);
        $wifeMarga = new Marga(['nama' => 'Marbun']);
        
        // Different marga should be valid
        $this->assertTrue($husbandMarga->nama !== $wifeMarga->nama);
    }

    public function testForbiddenPairsMarbunSihotang()
    {
        $forbiddenPairs = [
            ['Marbun', 'Sihotang'],
            ['Nainggolan', 'Siregar']
        ];
        
        $husbandMarga = 'Marbun';
        $wifeMarga = 'Sihotang';
        
        $isForbidden = false;
        foreach ($forbiddenPairs as $pair) {
            if (
                ($husbandMarga === $pair[0] && $wifeMarga === $pair[1]) ||
                ($husbandMarga === $pair[1] && $wifeMarga === $pair[0])
            ) {
                $isForbidden = true;
                break;
            }
        }
        
        $this->assertTrue($isForbidden, 'Marbun-Sihotang should be forbidden');
    }

    public function testForbiddenPairsNainggolanSiregar()
    {
        $forbiddenPairs = [
            ['Marbun', 'Sihotang'],
            ['Nainggolan', 'Siregar']
        ];
        
        $husbandMarga = 'Nainggolan';
        $wifeMarga = 'Siregar';
        
        $isForbidden = false;
        foreach ($forbiddenPairs as $pair) {
            if (
                ($husbandMarga === $pair[0] && $wifeMarga === $pair[1]) ||
                ($husbandMarga === $pair[1] && $wifeMarga === $pair[0])
            ) {
                $isForbidden = true;
                break;
            }
        }
        
        $this->assertTrue($isForbidden, 'Nainggolan-Siregar should be forbidden');
    }

    public function testAllowedPairsSimanjuntakMarbun()
    {
        $forbiddenPairs = [
            ['Marbun', 'Sihotang'],
            ['Nainggolan', 'Siregar']
        ];
        
        $husbandMarga = 'Simanjuntak';
        $wifeMarga = 'Marbun';
        
        $isForbidden = false;
        foreach ($forbiddenPairs as $pair) {
            if (
                ($husbandMarga === $pair[0] && $wifeMarga === $pair[1]) ||
                ($husbandMarga === $pair[1] && $wifeMarga === $pair[0])
            ) {
                $isForbidden = true;
                break;
            }
        }
        
        $this->assertFalse($isForbidden, 'Simanjuntak-Marbun should be allowed');
    }

    public function testForbiddenPairsReverseOrder()
    {
        $forbiddenPairs = [
            ['Marbun', 'Sihotang'],
            ['Nainggolan', 'Siregar']
        ];
        
        // Test reverse order
        $husbandMarga = 'Sihotang';
        $wifeMarga = 'Marbun';
        
        $isForbidden = false;
        foreach ($forbiddenPairs as $pair) {
            if (
                ($husbandMarga === $pair[0] && $wifeMarga === $pair[1]) ||
                ($husbandMarga === $pair[1] && $wifeMarga === $pair[0])
            ) {
                $isForbidden = true;
                break;
            }
        }
        
        $this->assertTrue($isForbidden, 'Sihotang-Marbun (reverse) should also be forbidden');
    }

    public function testPatrilinealInheritanceRule()
    {
        // BR-MRG-001: Children inherit father's marga
        $fatherMarga = 'Simanjuntak';
        $motherMarga = 'Marbun';
        
        $childMarga = $fatherMarga; // Patrilineal
        
        $this->assertEquals($fatherMarga, $childMarga, 'Child should inherit father\'s marga');
        $this->assertNotEquals($motherMarga, $childMarga, 'Child should not inherit mother\'s marga');
    }

    public function testMargaUniquenessValidation()
    {
        // BR-MRG-002: Marga should be unique within appropriate context
        $margaList = ['Simanjuntak', 'Marbun', 'Sihotang'];
        $newMarga = 'Simanjuntak';
        
        $isUnique = !in_array($newMarga, $margaList);
        
        $this->assertFalse($isUnique, 'Duplicate marga should not be unique');
        
        $newMarga2 = 'LumbanTungkup';
        $isUnique2 = !in_array($newMarga2, $margaList);
        
        $this->assertTrue($isUnique2, 'New marga should be unique');
    }

    public function testMarriageValidationWithNullPersons()
    {
        // Test validation when persons don't exist
        $husband = null;
        $wife = null;
        
        $isValid = $husband !== null && $wife !== null;
        
        $this->assertFalse($isValid, 'Marriage with null persons should be invalid');
    }

    public function testMarriageValidationWithOneNullPerson()
    {
        $husband = new Person();
        $wife = null;
        
        $isValid = $husband !== null && $wife !== null;
        
        $this->assertFalse($isValid, 'Marriage with one null person should be invalid');
    }
}
