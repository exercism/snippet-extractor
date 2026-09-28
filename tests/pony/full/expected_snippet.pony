primitive TwoFer
  fun apply(name: String = "you"): String =>
    """
    Docstrings are string literals so they can't be safely removed
    """
    "One for " + name + ", one for me." // inline comment
