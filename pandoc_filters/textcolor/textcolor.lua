-- textcolor.lua
--
-- Preserve LaTeX `\textcolor{COLOR}{TEXT}` markup when rendering to .docx.
--
-- Background: pandoc's docx writer silently drops raw LaTeX commands such as
-- `\textcolor{...}{...}`, so colored inline text written in the manuscript
-- source disappears in Word output (PDF/LaTeX builds are unaffected because
-- LaTeX renders the command natively). This filter rewrites those raw LaTeX
-- inlines into colored runs of OpenXML so the author-specified color survives
-- the docx round trip.
--
-- The filter is a no-op for any non-docx writer, so it is safe to include in
-- shared pipelines without altering PDF or other outputs.
--
-- Color argument may be either:
--   * a named color present in COLOR_MAP (e.g. red, yellow, brickred), or
--   * a 6-digit hex value with or without a leading `#` (e.g. #ff8800).
-- Unknown names fall back to black so the text remains visible; extend
-- COLOR_MAP below as new named colors come into use in manuscripts.
--
-- Note: the inner argument is treated as plain text. Nested formatting inside
-- `\textcolor{...}{ ... }` (bold, math, citations, etc.) is not currently
-- supported because we emit a single OpenXML run; extend with a Span-based
-- approach if that need arises.

local COLOR_MAP = {
  red       = "FF0000",
  yellow    = "FFFF00",
  orange    = "FFA500",
  blue      = "0000FF",
  green     = "008000",
  purple    = "800080",
  gray      = "808080",
  grey      = "808080",
  black     = "000000",
  white     = "FFFFFF",
  brickred  = "B22222",
}

local function normalize_color(name)
  if not name then return "000000" end
  local hex = name:match("^#?(%x%x%x%x%x%x)$")
  if hex then return hex:upper() end
  return COLOR_MAP[name:lower()] or "000000"
end

local function xml_escape(s)
  return (s:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
end

function RawInline(elem)
  if not FORMAT:match("docx") then return nil end
  if elem.format ~= "tex" and elem.format ~= "latex" then return nil end

  local color, text = elem.text:match("^\\textcolor%s*{([^}]+)}%s*{(.-)}$")
  if not color then return nil end

  local hex = normalize_color(color)
  local run = string.format(
    '<w:r><w:rPr><w:color w:val="%s"/></w:rPr>' ..
    '<w:t xml:space="preserve">%s</w:t></w:r>',
    hex, xml_escape(text)
  )
  return pandoc.RawInline("openxml", run)
end
