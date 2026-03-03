-- bylaws-numbering.lua
-- Pandoc Lua filter that automatically prefixes bylaw headings with
-- "Article N:", "Section N:", or "Subsection A:" based on heading level.
--
-- Level 2 (##)  → Article 1, Article 2, …         (never resets)
-- Level 3 (###) → Section 1, Section 2, …         (resets each Article)
-- Level 4 (####)→ Subsection A, Subsection B, …   (resets each Section)

local article_n    = 0
local section_n    = 0
local subsection_n = 0

local function to_letter(n)
  return string.char(64 + n)  -- 1 → "A", 2 → "B", …
end

local function prepend(content, str)
  local result = {pandoc.Str(str)}
  for _, v in ipairs(content) do
    table.insert(result, v)
  end
  return result
end

function Header(el)
  if el.level == 2 then
    article_n    = article_n + 1
    section_n    = 0
    subsection_n = 0
    el.content   = prepend(el.content, "Article " .. article_n .. ": ")

  elseif el.level == 3 then
    section_n    = section_n + 1
    subsection_n = 0
    el.content   = prepend(el.content, "Section " .. section_n .. ": ")

  elseif el.level == 4 then
    subsection_n = subsection_n + 1
    local letter = to_letter(subsection_n)
    if #el.content == 0 then
      el.content = pandoc.Inlines({pandoc.Str("Subsection " .. letter)})
    else
      el.content = prepend(el.content, "Subsection " .. letter .. ": ")
    end
  end

  return el
end
