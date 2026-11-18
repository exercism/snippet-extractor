#!/usr/bin/env lua
-- Pangram check
-- Returns true if every letter appears at least once.

--[[
  This is a block comment
  spread over several lines.
]]

--[==[ Alternative block comment ]==]
local Pangram = {}

function Pangram.is_pangram(s)
  local letters = {}
  for c in s:lower():gmatch('%a') do
    letters[c:byte()] = true
  end
  local count = 0
  for _ in pairs(letters) do
    count = count + 1
  end
  return count == 26
end

return Pangram
