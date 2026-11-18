/*
 * Armstrong numbers.
 * A number is an Armstrong number if it equals the sum of its digits
 * each raised to the number of digits.
 */
#ifndef ARMSTRONG_NUMBERS_H
#pragma once
#include "armstrong_numbers.h"

// Helpers
#include <stdint.h>
#include <math.h>

static uint16_t get_digit_count(uint32_t candidate)
{
   uint16_t count = 0;
   while (candidate > 0) {
      candidate /= 10;
      count++;
   }
   return count;
}

bool is_armstrong_number(uint32_t candidate)
{
   return false;
}
