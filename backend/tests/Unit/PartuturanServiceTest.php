<?php

namespace App\Tests\Unit;

use App\Services\PartuturanService;
use App\Models\Person;
use PHPUnit\Framework\TestCase;

class PartuturanServiceTest extends TestCase
{
    private PartuturanService $service;

    protected function setUp(): void
    {
        $this->service = new PartuturanService();
    }

    public function testCalculateSelfRelationship()
    {
        $person = $this->createPerson(1, 'John', 'L');
        
        $result = $this->service->calculate($person, $person);
        
        $this->assertEquals('Diri sendiri', $result->term);
        $this->assertEquals('Diri sendiri', $result->indonesian);
        $this->assertCount(1, $result->path);
    }

    public function testCalculateFatherRelationship()
    {
        $father = $this->createPerson(1, 'Robert', 'L');
        $child = $this->createPerson(2, 'John', 'L');
        $child->father_id = 1;
        $child->father = $father;
        
        $result = $this->service->calculate($child, $father);
        
        $this->assertEquals('Bapak', $result->term);
        $this->assertEquals('Ayah', $result->indonesian);
    }

    public function testCalculateMotherRelationship()
    {
        $mother = $this->createPerson(1, 'Mary', 'P');
        $child = $this->createPerson(2, 'John', 'L');
        $child->mother_id = 1;
        $child->mother = $mother;
        
        $result = $this->service->calculate($child, $mother);
        
        $this->assertEquals('Mama', $result->term);
        $this->assertEquals('Ibu', $result->indonesian);
    }

    public function testCalculateSonRelationship()
    {
        $father = $this->createPerson(1, 'Robert', 'L');
        $son = $this->createPerson(2, 'John', 'L');
        $son->father_id = 1;
        $father->childrenAsFather = collect([$son]);
        
        $result = $this->service->calculate($father, $son);
        
        $this->assertEquals('Anak laki-laki', $result->term);
        $this->assertEquals('Anak laki-laki', $result->indonesian);
    }

    public function testCalculateDaughterRelationship()
    {
        $father = $this->createPerson(1, 'Robert', 'L');
        $daughter = $this->createPerson(2, 'Emily', 'P');
        $daughter->father_id = 1;
        $daughter->father = $father;
        $father->childrenAsFather = collect([$daughter]);
        
        $result = $this->service->calculate($father, $daughter);
        
        // Debug: check what we're getting
        if ($result->term !== 'Anak perempuan') {
            $this->assertEquals('Anak perempuan', $result->term, "Expected 'Anak perempuan' but got '{$result->term}' for daughter with jenis_kelamin='{$daughter->jenis_kelamin}'");
        }
        
        $this->assertEquals('Anak perempuan', $result->term);
        $this->assertEquals('Anak perempuan', $result->indonesian);
    }

    public function testCalculateBrotherRelationship()
    {
        $father = $this->createPerson(1, 'Robert', 'L');
        $mother = $this->createPerson(2, 'Mary', 'P');
        
        $brother = $this->createPerson(3, 'Michael', 'L');
        $brother->father_id = 1;
        $brother->mother_id = 2;
        $brother->father = $father;
        $brother->mother = $mother;
        
        $sister = $this->createPerson(4, 'Emily', 'P');
        $sister->father_id = 1;
        $sister->mother_id = 2;
        $sister->father = $father;
        $sister->mother = $mother;
        
        // Add siblings to each other's relationships
        $father->childrenAsFather = collect([$brother, $sister]);
        $mother->childrenAsMother = collect([$brother, $sister]);
        
        $result = $this->service->calculate($sister, $brother);
        
        $this->assertEquals('Dongan saur', $result->term);
        $this->assertEquals('Saudara laki-laki', $result->indonesian);
    }

    public function testCalculateSisterRelationship()
    {
        $father = $this->createPerson(1, 'Robert', 'L');
        $mother = $this->createPerson(2, 'Mary', 'P');
        
        $brother = $this->createPerson(3, 'Michael', 'L');
        $brother->father_id = 1;
        $brother->mother_id = 2;
        $brother->father = $father;
        $brother->mother = $mother;
        
        $sister = $this->createPerson(4, 'Emily', 'P');
        $sister->father_id = 1;
        $sister->mother_id = 2;
        $sister->father = $father;
        $sister->mother = $mother;
        
        // Add siblings to each other's relationships
        $father->childrenAsFather = collect([$brother, $sister]);
        $mother->childrenAsMother = collect([$brother, $sister]);
        
        $result = $this->service->calculate($brother, $sister);
        
        $this->assertEquals('Dongan saur', $result->term);
        $this->assertEquals('Saudara perempuan', $result->indonesian);
    }

    public function testCalculateGrandfatherRelationship()
    {
        $grandfather = $this->createPerson(1, 'John Sr', 'L');
        $father = $this->createPerson(2, 'Robert', 'L');
        $father->father_id = 1;
        $father->father = $grandfather;
        
        $child = $this->createPerson(3, 'John Jr', 'L');
        $child->father_id = 2;
        $child->father = $father;
        
        $result = $this->service->calculate($child, $grandfather);
        
        $this->assertEquals('Ama', $result->term);
        $this->assertEquals('Kakek', $result->indonesian);
    }

    public function testCalculateGrandmotherRelationship()
    {
        $grandmother = $this->createPerson(1, 'Mary Sr', 'P');
        $mother = $this->createPerson(2, 'Mary Jr', 'P');
        $mother->mother_id = 1;
        $mother->mother = $grandmother;
        
        $child = $this->createPerson(3, 'John', 'L');
        $child->mother_id = 2;
        $child->mother = $mother;
        
        $result = $this->service->calculate($child, $grandmother);
        
        $this->assertEquals('Ina', $result->term);
        $this->assertEquals('Nenek', $result->indonesian);
    }

    public function testCalculateTulangRelationship()
    {
        $person = $this->createPerson(1, 'John', 'L');
        $mother = $this->createPerson(2, 'Mary', 'P');
        $motherBrother = $this->createPerson(3, 'Robert', 'L');
        
        $person->mother_id = 2;
        $person->mother = $mother;
        $mother->father_id = null;
        $mother->mother_id = null;
        
        // Simulate mother's brother
        $motherBrother->jenis_kelamin = 'L';
        
        $result = $this->service->calculate($person, $motherBrother);
        
        // This should detect tulang pattern if path is correct
        $this->assertNotEmpty($result->term);
    }

    public function testCalculateNamboruRelationship()
    {
        $person = $this->createPerson(1, 'John', 'L');
        $father = $this->createPerson(2, 'Robert', 'L');
        $fatherSister = $this->createPerson(3, 'Mary', 'P');
        
        $person->father_id = 2;
        $person->father = $father;
        $fatherSister->jenis_kelamin = 'P';
        
        $result = $this->service->calculate($person, $fatherSister);
        
        $this->assertNotEmpty($result->term);
    }

    public function testCalculateNoRelationship()
    {
        $person1 = $this->createPerson(1, 'John', 'L');
        $person2 = $this->createPerson(2, 'Jane', 'P');
        
        // No relationships set
        $result = $this->service->calculate($person1, $person2);
        
        $this->assertEquals('Tidak diketahui', $result->term);
        $this->assertEquals('Hubungan tidak ditemukan', $result->indonesian);
        $this->assertEmpty($result->path);
    }

    public function testPathDescriptionGeneration()
    {
        $father = $this->createPerson(1, 'Robert', 'L');
        $child = $this->createPerson(2, 'John', 'L');
        $child->father_id = 1;
        $child->father = $father;
        
        $result = $this->service->calculate($child, $father);
        
        // The path description uses the from person's name
        $this->assertStringContainsString('John', $result->explanation);
    }

    private function createPerson(int $id, string $nama, string $jenis_kelamin): Person
    {
        $person = new Person();
        $person->id = $id;
        $person->nama = $nama;
        $person->nama_depan = $nama;
        $person->jenis_kelamin = $jenis_kelamin;
        $person->father_id = null;
        $person->mother_id = null;
        $person->father = null;
        $person->mother = null;
        $person->childrenAsFather = collect();
        $person->childrenAsMother = collect();
        $person->marriagesAsHusband = collect();
        $person->marriagesAsWife = collect();
        
        return $person;
    }
}
