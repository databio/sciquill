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

print("supplemental labels")
if FORMAT:match 'latex' then




  function Meta(m)
    print("testing")
    -- print(dump(m))
    if m['off'] then
      off = true
      print("Setting images to off")
    end
  end


  function Image(elem)
    print("Image")
    print(dump(elem))
    if elem.attributes.label then
      print("don't display this image")
      rval = {}
      -- print(dump(rval))
      lab = "no label"
      if elem.attributes.label then
        lab = elem.attributes.label
      else
        lab = "no label"
      end
      print(dump(lab))
      print("Label" .. lab)

      x = {
        pandoc.RawInline('latex', [[\captionof{figure}{\label{]] .. lab .. '}}')
      }
      -- print(dump(x))
      return x
      -- return pandoc.Null()
    else
      print("display this image")
      return elem
    end
  end
end

return {
  { Meta = Meta },  -- (1)
  { Image = Image }     -- (2)
}