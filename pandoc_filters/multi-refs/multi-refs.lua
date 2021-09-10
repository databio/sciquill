-- pandoc.utils.make_sections exists since pandoc 2.8
if PANDOC_VERSION == nil then -- if pandoc_version < 2.1
  error("ERROR: pandoc >= 2.1 required for multi-refs filter")
else
  PANDOC_VERSION:must_be_at_least {2,8}
end

local utils = require 'pandoc.utils'
local run_json_filter = utils.run_json_filter

--- The document's metadata
local meta

-- Storage for intermediate references
local myrefs = {}
local allrefs
local split_refs = {}
local processed_entries = {}
local accumulated_refids = {}


-- Index variable for reference section (order)
local iref = 1

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


function iter(o)
   if type(o) == 'table' then
    if o.classes and table.contains(o.classes, "multi-refs") then
        print("FOUND IT!")
    end
      local s = '{'
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. "iter(v)" .. ','
      end
      return s .. '}\n'
   else
      return tostring(o)
   end
end


function print_citation_keys(refs)
  for k,v in pairs(refs) do
    print(k, v.identifier)
  end
end

-- Save copied tables in `copies`, indexed by original table.
function deepcopy(orig, copies)
    copies = copies or {}
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        if copies[orig] then
            copy = copies[orig]
        else
            copy = {}
            copies[orig] = copy
            for orig_key, orig_value in next, orig, nil do
                copy[deepcopy(orig_key, copies)] = deepcopy(orig_value, copies)
            end
            setmetatable(copy, deepcopy(getmetatable(orig), copies))
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

-- Find a particular identified div, recursively through block subsections
function find_div_by_id(block, identifier)
  if not block then
    return nil
  end
  return block:find_if(function(x)
    return x.identifier==identifier
    or find_div_by_id(x.content, identifier) end)
end

function find_div_by_class(block, class)
  -- if not block then
  --   return nil
  -- end
  
  return pandoc.List:find_if(
    function(x)
      if x.classes and table.contains(x.classes, class) then
        return true
    else
      return find_div_by_class(x.content, class)
    end
    end)
end

-- stackoverflow
function table.contains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end


local function run_citeproc (doc)
  if PANDOC_VERSION >= '2.11' then
    local args = {'--from=json', '--to=json', '--citeproc'}
    return run_json_filter(doc, 'pandoc', args)
  else
    return run_json_filter(doc, 'pandoc-citeproc', {FORMAT, '-q'})
  end
end

-- Populate the multi-refs div with references
local function check_div (div)
  if table.contains(div.classes, "multi-refs") then
    print("Populating bibliography for multi-refs div, number: ", iref)
    -- print("split_refs", dump(split_refs[iref]))
    -- print("myrefs", dump(myrefs[iref]))
    -- div.content = myrefs[iref] # old way
    div.content = split_refs[iref]
    iref = iref+1
  end
  return div
end

local function make_refs_subset(allrefs, subset_ids)
  local local_refs_subset = deepcopy(allrefs)
  local_refs_subset.content = {}
  local i = 1
  for k,v in pairs(allrefs.content) do
    already_included = false
    for idnum, refid in pairs(subset_ids) do 
      if "ref-"..refid==v.identifier then
        print(k, idnum, refid, v.identifier)
        if processed_entries[v.identifier] then
          print("reference included in previous bibliography:", v.identifier)
          already_included = true
        end
        if meta['multiref_no_duplicates'] and already_included then
          print("skipping")
        else
          local_refs_subset.content[i] = v
          i = i+1
          processed_entries[v.identifier] = v.identifier
        end
      end
    end
  end
  -- print("Refs subset: ", dump(local_refs_subset))
  table.insert(split_refs, {local_refs_subset})
end

local function recurse(content)
  for k,v in pairs(content) do
    -- print(k, type(v))
    if type(v) == 'table' then
      if v.mode and v.mode == "NormalCitation" then
        -- print("Found a ref", dump(v.id), dump(v))
        table.insert(accumulated_refids, v.id)
      end
      if v.content and v.classes and table.contains(v.classes, "multi-refs") then
        print("Found a multi-refs div. Ref count:", #accumulated_refids)
        -- print("Accumulated refids: ", dump(accumulated_refids))
        make_refs_subset(allrefs, accumulated_refids)
        accumulated_refids = {} -- clear it
      end
      recurse(v)
      -- end
    end
  end
end


local function traverse_doc(doc)
  -- get the complete citation table, which we will use to
  -- create the split versions
  doc_with_cites = run_citeproc(doc)
  allrefs = doc_with_cites.blocks:find_if(function (b)
    return b.identifier == 'refs'
  end)
  if not allrefs then
    return nil
  end
  -- allrefs is the table of all references. print its count
  print("Total citations: ", #allrefs.content)

  -- pandoc divides a doc into 'blocks', based on level-1 headings
  -- go through each of these
  for block_id,block_data in pairs(doc.blocks) do
    -- print(block_id, dump(block_data.content))
    recurse(block_data)
  end
end

--- Filter to the references div and bibliography header added by
--- pandoc-citeproc.
local remove_pandoc_citeproc_results = {
  Header = function (header)
    return header.identifier == 'bibliography'
      and {}
      or nil
  end,
  Div = function (div)
    return div.identifier == 'refs'
      and {}
      or nil
  end
}

local function restore_bibliography (meta)
  meta.bibliography = orig_bibliography
  return meta
end

--- Set up: wrap all sections in Div elements.
function set_up_document (doc)
  -- save meta for other filter functions
  meta = doc.meta
  local sections = utils.make_sections(true, nil, doc.blocks)
  return pandoc.Pandoc(sections, doc.meta)
end

return {
  -- remove result of previous pandoc-citeproc run (for backwards
  -- compatibility)
  remove_pandoc_citeproc_results,
  {Pandoc = set_up_document},
  {Pandoc = traverse_doc},
  {Div = check_div},
  -- {Cite = process_citations},
  -- {Blocks = Blocks},
  -- {Div = create_section_bibliography},
  -- {Div = flatten_sections, Meta = restore_bibliography}
}


-- DEPRECATED WAY TO DO IT THAT REQUIRED THE DIVS
-- BE AT THE END OF LEVEL-1 SECTIONS, AND ALSO WAS MUCH
-- MORE COMPLICATED.
-- local function check_doc (doc)
--   local accumulated_blocks = {}
--   local refspace = {}

--   -- get the complete citation table, which we will split.
--   doc_with_cites = run_citeproc(doc)
--   allrefs = doc_with_cites.blocks:find_if(function (b)
--     return b.identifier == 'refs'
--   end)

--   if not allrefs then
--     return nil
--   end

--   -- allrefs is the table of all references. print its count
--   -- print("allrefs", dump(allrefs))
--   print("Total citations: ", #allrefs.content)

--   local currentref = 1
--   -- print(dump(doc))
--   for i0,el0 in pairs(doc.blocks) do
--   for i,el in pairs(el0) do
--     if i == "attr" then
--       goto continue
--     end

--     table.insert(accumulated_blocks, el)
--     print("Processing block " .. i0 .. ":" .. i)
--     print(dump(el))
--     -- does this block have a multi-refs div?
--     local has_multirefs_div = find_div_by_class(el.content, 'multi-refs')
--     local has_refs_div = find_div_by_id(el.content, 'refs')

--     if has_refs_div then
--       print("has refs div!")
--     end

--     if has_multirefs_div then
--       print("has multirefs div!")
--     end

--     if has_multirefs_div then 
--       -- identify the pandoc refs block
--       local tmp_doc = pandoc.Pandoc(accumulated_blocks, meta)
--       local new_doc = run_citeproc(tmp_doc)

--       -- ab_refs: accumulated_blocks refs section. That's refs found in these blocks.
--       local ab_refs = new_doc.blocks:find_if(function (b)
--         return b.identifier == 'refs'
--       end)

--       if not ab_refs then
--         print("No reference found in this block")
--       else

--         -- Number of citations in this section.
--         print("Processing citations for multi-refs div. N citations: ", #ab_refs.content)
--         print_citation_keys(ab_refs.content)
--         table.insert(myrefs, { ab_refs })
--         endval = #ab_refs.content+currentref-1
--         -- These lines of code are from a dead end I took that would
--         -- cut out a slice of refs from the main table; but this only worked
--         -- for citation styles that ordered by reference number, not alphabetically
--         -- local theserefs = {table.unpack(allrefs.content, currentref, endval)}
--         -- print("theserefs", dump(theserefs))
--         -- print_citation_keys(theserefs)

--         -- Grab a subset of allrefs for the ones in the current accumulated blocks
--         local local_refs_subset = deepcopy(allrefs)
--         local_refs_subset.content = {}
--         -- print("local_refs_subset", dump(local_refs_subset))
--         -- local_refs_subset.content = deepcopy(theserefs)
--         local i = 1
--         for k,v in pairs(allrefs.content) do
--           already_included = false
--           for k2,v2 in pairs(ab_refs.content) do   
--             if v2.identifier==v.identifier then
--               -- print(k, k2, v.identifier)
--               if processed_entries[v.identifier] then
--                 print("reference included in previous bibliography:", v.identifier)
--                 already_included = true
--               end
--               if meta['multiref_no_duplicates'] and already_included then
--                 print("skipping")
--               else
--                 local_refs_subset.content[i] = v
--                 i = i+1
--                 processed_entries[v.identifier] = v.identifier
--               end
--             end
--           end
--         end
--         currentref = #ab_refs.content +1
--         table.insert(split_refs, {local_refs_subset})
--         -- print("split_refs", dump(split_refs))
--         accumulated_blocks = {}
--       end
--     end
--   ::continue::    
--   end
--   end
--   return doc
-- end
