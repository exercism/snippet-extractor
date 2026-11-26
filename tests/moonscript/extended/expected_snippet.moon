change = (amount, denominations) ->
  C = {[0]: 0}
  S = {}

  for p = 1, amount
    min = math.maxinteger
    coin_idx = nil

    for i = 1, #denominations
      if denominations[i] <= p
        if C[p - denominations[i]] < min
          min = 1 + C[p - denominations[i]]
          coin_idx = i

    C[p] = min
