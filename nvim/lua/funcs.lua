function Contains(list, element)
  for _, v in ipairs(list) do
    if element == v then
      return true
    end
  end
  return false
end

---comment
---@param list table
---@param key string
---@param value any
---@return table
function Append(list, key, value)
  local new_list = {unpack(list)}
  new_list[key] = value
  return new_list
end
