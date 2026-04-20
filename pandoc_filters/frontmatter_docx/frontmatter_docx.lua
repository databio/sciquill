-- frontmatter_docx.lua
--
-- Render the manuscript title block (author list with affiliation superscripts,
-- institutional affiliations, and correspondence) in .docx output, mirroring
-- the layout produced by the sciquill PDF templates (shefflab.tex / authblk).
--
-- Pandoc's docx writer emits only `meta.title` and ignores the structured
-- `author` / `institutions` metadata used in sciquill manuscripts, so Word
-- output otherwise lacks the author block reviewers and journals expect.
-- This filter walks the document metadata at write time and inserts the
-- missing front matter immediately after the pandoc-emitted title, in
-- roughly the same visual order as the PDF version:
--
--   <Title>                                (pandoc, Title style)
--   Name1^aff,✉^, Name2^aff^, …            (Author style; ✉ flags corresp.)
--   ^key^Institution                       (one paragraph per institution)
--   ✉ Correspondence: addr1, addr2         (mailto-linked emails)
--   <Abstract>                             (relocated from meta to here)
--
-- The abstract is captured from `meta.abstract` and re-emitted *after* the
-- author/affiliation block to preserve the PDF reading order; pandoc's docx
-- writer would otherwise place it directly under the title (before the
-- authors), since metadata-driven blocks are inserted before doc.blocks.
--
-- Expected metadata shape (sciquill manuscript convention):
--   title: "..."
--   author:
--     - name: "Author Name"
--       affiliation: "1, †"            # comma-separated keys, free-form
--       correspondence: "a@x, b@y"     # optional; may appear on >=1 author
--   institutions:
--     - name: "Affiliation text"
--       key: "1"
--
-- Only active when FORMAT matches docx; other writers see no change so PDF
-- and other outputs remain driven by their existing templates.

local CORRESPONDENCE_GLYPH = "\u{2709}"  -- ✉ U+2709 ENVELOPE

local function meta_to_string(m)
  if m == nil then return nil end
  return pandoc.utils.stringify(m)
end

-- Parse a string as inline markdown so unicode, escapes, and light formatting
-- survive (e.g. the "†" symbol in affiliation keys).
local function inlines_from_string(s)
  if not s or s == "" then return {} end
  local parsed = pandoc.read(s, "markdown")
  if #parsed.blocks > 0 then
    local first = parsed.blocks[1]
    if first.t == "Plain" or first.t == "Para" then
      return first.content
    end
  end
  return { pandoc.Str(s) }
end

-- Split a "a@x, b@y" correspondence string into mailto-linked inlines.
local function emails_to_links(s)
  local out = pandoc.List({})
  local first = true
  for email in s:gmatch("[^,%s]+") do
    if not first then out:insert(pandoc.Str(", ")) end
    out:insert(pandoc.Link({ pandoc.Str(email) }, "mailto:" .. email))
    first = false
  end
  return out
end

-- Wrap a paragraph in a Div carrying a Word custom-style attribute so the
-- docx writer applies the named style. Falls back to a bare Para if style
-- is nil.
local function styled_para(inlines, style)
  local para = pandoc.Para(inlines)
  if not style then return para end
  return pandoc.Div({ para }, pandoc.Attr("", {}, { { "custom-style", style } }))
end

-- Coerce a Meta value (MetaBlocks / MetaInlines / MetaString / MetaList of
-- blocks) into a list of pandoc Blocks suitable for splicing into the body.
local function meta_to_blocks(m)
  if m == nil then return pandoc.List({}) end
  if m.t == "MetaBlocks" then
    return pandoc.List(m)
  elseif m.t == "MetaInlines" then
    return pandoc.List({ pandoc.Para(m) })
  else
    local txt = pandoc.utils.stringify(m)
    return pandoc.List(pandoc.read(txt, "markdown").blocks)
  end
end

function Pandoc(doc)
  if not FORMAT:match("docx") then return nil end

  local meta = doc.meta
  local new_blocks = pandoc.List({})
  local correspondences = pandoc.List({})

  -- Capture and clear the abstract so we can re-emit it after the author
  -- block. Otherwise pandoc auto-renders meta.abstract immediately below the
  -- title, ahead of our inserted front matter.
  local abstract_blocks = pandoc.List({})
  if meta.abstract then
    abstract_blocks = meta_to_blocks(meta.abstract)
    meta.abstract = nil
  end

  -- Authors: "Name^aff,✉^, Name^aff^, ..."
  if meta.author then
    local author_inlines = pandoc.List({})
    for i, a in ipairs(meta.author) do
      if i > 1 then author_inlines:insert(pandoc.Str(", ")) end

      local name = meta_to_string(a.name)
      if name then
        author_inlines:extend(inlines_from_string(name))
      end

      local sup = pandoc.List({})
      local aff = meta_to_string(a.affiliation)
      if aff and aff ~= "" then
        sup:extend(inlines_from_string(aff))
      end
      local corr = meta_to_string(a.correspondence)
      if corr and corr ~= "" then
        if #sup > 0 then sup:insert(pandoc.Str(",")) end
        sup:insert(pandoc.Str(CORRESPONDENCE_GLYPH))
        correspondences:insert(corr)
      end
      if #sup > 0 then
        author_inlines:insert(pandoc.Superscript(sup))
      end
    end
    -- Reuse the built-in "Author" Word style (present in pandoc's default
    -- reference.docx) so the author paragraph is visually distinct.
    new_blocks:insert(styled_para(author_inlines, "Author"))
  end

  -- Institutions: one paragraph each, "^key^ Name".
  if meta.institutions then
    for _, inst in ipairs(meta.institutions) do
      local name = meta_to_string(inst.name)
      local key  = meta_to_string(inst.key)
      if name then
        local line = pandoc.List({})
        if key and key ~= "" then
          line:insert(pandoc.Superscript(inlines_from_string(key)))
          line:insert(pandoc.Str(" "))
        end
        line:extend(inlines_from_string(name))
        new_blocks:insert(styled_para(line, "Affiliation"))
      end
    end
  end

  -- Correspondence: "✉ Correspondence: addr1, addr2"
  if #correspondences > 0 then
    local corr_inlines = pandoc.List({
      pandoc.Str(CORRESPONDENCE_GLYPH),
      pandoc.Str(" "),
      pandoc.Strong({ pandoc.Str("Correspondence:") }),
      pandoc.Str(" "),
    })
    for i, c in ipairs(correspondences) do
      if i > 1 then corr_inlines:insert(pandoc.Str("; ")) end
      corr_inlines:extend(emails_to_links(c))
    end
    new_blocks:insert(styled_para(corr_inlines, "Affiliation"))
  end

  -- Re-emit the abstract after the author block, wrapped in a Div with the
  -- "Abstract" custom-style so the docx writer applies the same Word style
  -- it would have used had it auto-rendered the abstract from metadata.
  if #abstract_blocks > 0 then
    new_blocks:insert(
      pandoc.Div(abstract_blocks,
        pandoc.Attr("", {}, { { "custom-style", "Abstract" } }))
    )
  end

  -- Prepend the new front matter to the existing body blocks. The
  -- pandoc-emitted Title paragraph is not in doc.blocks (it's written from
  -- metadata), so inserting at index 1 places this content immediately
  -- after the title in the rendered docx.
  for _, b in ipairs(doc.blocks) do
    new_blocks:insert(b)
  end
  doc.blocks = new_blocks
  doc.meta = meta
  return doc
end
