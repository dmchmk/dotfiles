function Contains(list, element)
  for _, v in ipairs(list) do
    if element == v then
      return true
    end
  end
  return false
end
