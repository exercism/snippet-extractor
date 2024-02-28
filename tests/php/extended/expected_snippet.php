public class Grains
{
    function square($n)
    {
        if ($n < 1 || $n > 64) {
            throw new InvalidArgumentException();
        }
        return pow(2, $n - 1);
    }

