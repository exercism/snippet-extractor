Gigasecond := datetime.Delta{seconds = 1e9}

add_gigasecond :: proc(time: datetime.DateTime) -> datetime.DateTime {  
    return datetime.add_delta_to_date(time, Gigasecond)
}
