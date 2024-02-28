<?php

namespace Lib\Exercism\Test;

use Lib\NotExercism;

// I love C#!! But get paid with PHP

/*
 * Comment
 */

public class Grains
{//comments
  //Comments
  /* Morestr 
    comments*/
    function square($n/*Even more comments*/)
    {
        if ($n < 1 || $n > 64) {
            throw new InvalidArgumentException();//Too large
        }
        return pow(2, $n - 1);// Just right
    }

    function total(/*I can be here supposedly*/)
    {
        return array_reduce(range(1, 64), function ($acc, $n) {
            return $acc += square($n);
        });
    }//This is the end of the program
}
