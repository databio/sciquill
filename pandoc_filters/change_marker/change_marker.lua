-- Inspired by oxforddown highlighter.

local mark_changes = false
local change_color = "red"  -- default change color

-- debugging function. Use it to dump a nested dict
function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

Meta = function(m)
  if m['mark_changes'] ~= nil then 
    mark_changes = m['mark_changes']
    print("Mark changes set to: ", m['mark_changes'])
  end
  if m['change_color'] ~= nil then
    change_color = m['change_color'][1].text
  end
end

Span = function (elem)

  local function isempty(s)
    return s == nil or s == ''
  end
  
  if FORMAT:match 'latex' then
    -- color text marked with [text to color]{.changed}
    if mark_changes and elem.classes[1] == "changed" then
      table.insert(
        elem.content, 1, 
        pandoc.RawInline('latex', '\\textcolor{'..change_color..'}{')
      )
      table.insert(
        elem.content, 
        pandoc.RawInline('latex', '}')
      )
    end
    return elem.content 
  end
end

return {
  { Meta = Meta },
  { Span = Span }
}