static uint16_t get_digit_count(uint32_t candidate)
{
   uint16_t count = 0;
   while (candidate > 0) {
      candidate /= 10;
      count++;
   }
   return count;
}

