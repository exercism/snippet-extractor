// Package gigasecond constains functionality to add a gigasecond
// to a period of time
package gigasecond

import "core:time/datetime"

/*Giga seconds
are 10^3 bigger than Mega seconds
*/
Gigasecond := datetime.Delta{seconds = 1e9}

// add_gigasecond adds a Gigasecond to the given time
add_gigasecond :: proc(time: datetime.DateTime) -> datetime.DateTime {  //Even more comments
    /* We'll ignore any errors
     */
    return datetime.add_delta_to_date(time, Gigasecond)
}
