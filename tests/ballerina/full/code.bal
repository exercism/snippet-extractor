import ballerina/io

// Package gigasecond constains functionality to add a gigasecond
// to a period of time

# Add one billion seconds to a time
#
# + timestamp - a string representing the starting time
# + return - a string representing the end time
function addGigasecond(string timestamp) returns string {
    Utc epoch = check time:utcFromString(timestamp);
    return epoch.utcAddSeconds(1000000000).utcToString();
}
