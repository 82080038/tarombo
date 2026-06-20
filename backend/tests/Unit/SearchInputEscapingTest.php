<?php

namespace App\Tests\Unit;

use PHPUnit\Framework\TestCase;

class SearchInputEscapingTest extends TestCase
{
    public function testWildcardCharactersAreEscaped()
    {
        $input = '100%free';
        $escaped = str_replace(['\\', '%', '_'], ['\\\\', '\\%', '\\_'], $input);
        $this->assertEquals('100\\%free', $escaped);
    }

    public function testUnderscoreIsEscaped()
    {
        $input = 'test_name';
        $escaped = str_replace(['\\', '%', '_'], ['\\\\', '\\%', '\\_'], $input);
        $this->assertEquals('test\\_name', $escaped);
    }

    public function testBackslashIsEscaped()
    {
        $input = 'path\\to\\name';
        $escaped = str_replace(['\\', '%', '_'], ['\\\\', '\\%', '\\_'], $input);
        $this->assertEquals('path\\\\to\\\\name', $escaped);
    }

    public function testNormalStringIsUnchanged()
    {
        $input = 'Nainggolan';
        $escaped = str_replace(['\\', '%', '_'], ['\\\\', '\\%', '\\_'], $input);
        $this->assertEquals('Nainggolan', $escaped);
    }

    public function testMultipleWildcardsAreAllEscaped()
    {
        $input = '%_\\';
        $escaped = str_replace(['\\', '%', '_'], ['\\\\', '\\%', '\\_'], $input);
        $this->assertEquals('\\%\\_\\\\', $escaped);
    }

    public function testEmptyStringIsHandled()
    {
        $input = '';
        $escaped = str_replace(['\\', '%', '_'], ['\\\\', '\\%', '\\_'], $input);
        $this->assertEquals('', $escaped);
    }
}
