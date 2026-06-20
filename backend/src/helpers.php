<?php

use Carbon\Carbon;

if (!function_exists('now')) {
    function now(): Carbon
    {
        return Carbon::now();
    }
}
