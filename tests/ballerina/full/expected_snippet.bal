function addGigasecond(string timestamp) returns string {
    Utc epoch = check time:utcFromString(timestamp);
    return epoch.utcAddSeconds(1000000000).utcToString();
}
