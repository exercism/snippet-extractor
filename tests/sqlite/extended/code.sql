-- single line comment
UPDATE leap
SET is_leap = 1-- comment at the end of a line
WHERE year % 4 = 0  AND /* comment in the middle of a line */(year % 100 != 0 OR year % 400 = 0);
