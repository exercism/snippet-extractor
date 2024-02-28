<?php

namespace Lib\Exercism\Test;

use Lib\NotExercism;

// I love C#!! But get paid with PHP

/*
 * Comment
 */

public class Grains
{
    function square($n)
    {
        if ($n < 1 || $n > 64) {
            throw new InvalidArgumentException();
        }
        return pow(2, $n - 1);
    }

    function total()
    {
        return array_reduce(range(1, 64), function ($acc, $n) {
            return $acc += square($n);
        });
    }
}
