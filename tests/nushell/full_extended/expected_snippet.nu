def vip-greet [
  vip: string       
   ...names: string 
] {
  for $name in $names {
    print $"Hello, ($name)!"
  }

  print $"And a special welcome to our VIP today, ($vip)!"
}

vip-greet Bob
