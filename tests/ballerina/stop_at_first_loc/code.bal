import ballerina/io

// Package gigasecond constains functionality to add a gigasecond
// to a period of time

# a Doc Comment
function addGigasecond(string timestamp) returns string {
    // expects input in RFC 3339 format (e.g., 2007-12-03T10:15:30.00Z)
    Utc epoch = check time:utcFromString(timestamp);
    return epoch.utcAddSeconds(1000000000).utcToString();
}
