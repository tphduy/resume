-- Dimmed under-brackets show the name structure. Words stay in the H1 in order;
-- labels are CSS-only decoration, so the heading text and accessible name are unchanged.
local NAME_PARTS = {
  { words = { "Tran" }, label = "Family" },
  { words = { "Pham", "Hoang" }, label = "Middle" },
  { words = { "Duy" }, label = "Given" },
}

local function mark_name_structure(header)
  local words = {}
  for word in pandoc.utils.stringify(header):gmatch("%S+") do
    words[#words + 1] = word
  end
  local expected = {}
  for _, part in ipairs(NAME_PARTS) do
    for _, word in ipairs(part.words) do
      expected[#expected + 1] = word
    end
  end
  if table.concat(words, " ") ~= table.concat(expected, " ") then
    return
  end

  local inlines = pandoc.Inlines({})
  for index, part in ipairs(NAME_PARTS) do
    if index > 1 then
      inlines:insert(pandoc.Space())
    end
    local content = pandoc.Inlines({})
    for word_index, word in ipairs(part.words) do
      if word_index > 1 then
        content:insert(pandoc.Space())
      end
      content:insert(pandoc.Str(word))
    end
    inlines:insert(pandoc.Span(content, pandoc.Attr("", { "name-part" }, { { "data-label", part.label } })))
  end
  header.content = inlines
end

-- Move the existing identity into the web hero without duplicating resume text.
function Pandoc(doc)
  local blocks = doc.blocks
  if not (blocks[1] and blocks[1].t == "Header" and blocks[1].level == 1
      and blocks[2] and blocks[2].t == "Para"
      and blocks[3] and blocks[3].t == "Div"
      and blocks[3].classes:includes("contact-details")
      and blocks[4] and blocks[4].t == "Header" and blocks[4].level == 2) then
    error("Web resume must begin with a name H1, role paragraph, contact paragraph, then an H2 section.")
  end

  mark_name_structure(blocks[1])
  doc.meta["resume-name"] = pandoc.MetaBlocks({blocks[1]})
  doc.meta["resume-role"] = pandoc.MetaBlocks({blocks[2]})
  doc.meta["resume-contact"] = pandoc.MetaBlocks({blocks[3]})
  for _ = 1, 3 do
    blocks:remove(1)
  end
  return doc
end
