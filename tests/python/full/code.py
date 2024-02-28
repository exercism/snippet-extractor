#!/usr/bin/env python3
# The above is sometimes used to note
# where the python interpreter is located.

# And after this comes the import statements, if any:
import re
from collections import Counter

# And then any constants or globals,
# followed by code.
WORDS = re.compile("[a-z0-9]+(['][a-z]+)?")

def count_words(text):
    return Counter(word.group(0) for word in WORDS.finditer(text.lower()))
