-- function Strong(elem)
--   return pandoc.SmallCaps(elem.c)
-- end


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


-- use by adding {wrap=3} to the image
if FORMAT:match 'latex' then
  function Image(elem)
    -- wrap figures.
    size=2
    print(elem.src)
    -- print(dump(elem))
    -- print(dump(elem.caption))
    -- print(pandoc.utils.stringify(elem.caption))
    if elem.attributes.wrap then
      local wrappos  
      if elem.attributes.wrappos then
        wrappos = elem.attributes.wrappos
      else
        wrappos = "R"
      end
      local latex_begin=[[\setlength{\intextsep}{2pt}\setlength{\columnsep}{8pt}\begin{wrapfigure}{]] .. wrappos ..[[}{]] .. elem.attributes.wrap .. '}'
      local latex_fig = [[\centering\includegraphics{]] .. elem.src .. [[}\caption{]]
      local latex_end = [[}\vspace{0pt}\end{wrapfigure}]]
      -- print(dump(pandoc.RawInline('latex', latex_begin)))
      return_value =  {
        pandoc.RawInline('latex', latex_begin),
        pandoc.RawInline('latex', latex_fig),
        pandoc.RawInline('latex', latex_end)
      }
      rval = elem.caption
      table.insert(rval, 1, pandoc.RawInline('latex', latex_fig))
      table.insert(rval, 1, pandoc.RawInline('latex', latex_begin))
      table.insert(rval, pandoc.RawInline('latex', latex_end))
      -- print(dump(rval))
      -- print(pandoc.utils.stringify(rval))
      return rval
    elseif elem.attributes.fullwidth then
      local latex_begin
      latex_begin=[[\setlength{\intextsep}{2pt}\setlength{\columnsep}{8pt}\begin{figure*}]] .. '[' .. elem.attributes.fullwidth .. ']'
      local latex_fig = [[\centering\includegraphics{]] .. elem.src .. [[}\caption{]]
      local latex_end = [[}\vspace{-5pt}\end{figure*}]]
      -- print(dump(pandoc.RawInline('latex', latex_begin)))
      return_value =  {
        pandoc.RawInline('latex', latex_begin),
        pandoc.RawInline('latex', latex_fig),
        pandoc.RawInline('latex', latex_end)
      }
      rval = elem.caption
      table.insert(rval, 1, pandoc.RawInline('latex', latex_fig))
      table.insert(rval, 1, pandoc.RawInline('latex', latex_begin))
      table.insert(rval, pandoc.RawInline('latex', latex_end))
      -- print(dump(rval))
      print(pandoc.utils.stringify(rval))
      return rval
    else
      return elem
    end
  end
end

