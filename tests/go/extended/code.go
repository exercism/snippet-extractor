// Package gigasecond constains functionality to add a gigasecond
// to a period of time
package gigasecond

import "time"

// AddGigasecond adds a Gigasecond to the given time
func AddGigasecond(t time.Time) time.Time {//Even more comments
  /*Giga seconds
  are 10^3 bigger than Mega seconds
  */
  return t.Add(time.Second * 1e9)
}
