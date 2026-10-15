-- Derive presentation from the source contact paragraph for both editions.
function Pandoc(doc)
  local contact = doc.blocks[3]
  if not (doc.blocks[1] and doc.blocks[1].t == "Header"
      and doc.blocks[1].level == 1 and doc.blocks[2].t == "Para"
      and contact and contact.t == "Para"
      and doc.blocks[4] and doc.blocks[4].t == "Header"
      and doc.blocks[4].level == 2) then
    error("Resume must begin with a name H1, role paragraph, contact paragraph, then an H2 section.")
  end

  local items, item = {}, pandoc.List()
  local function finish()
    while item[1] and item[1].t == "Space" do item:remove(1) end
    while item[#item] and item[#item].t == "Space" do item:remove(#item) end
    if #item > 0 then table.insert(items, item) end
    item = pandoc.List()
  end
  for _, inline in ipairs(contact.content) do
    if inline.t == "Str" and inline.text == "·" then finish()
    else item:insert(inline) end
  end
  finish()

  local location, email, profile
  local phones = {}
  for index, inlines in ipairs(items) do
    local link
    for _, inline in ipairs(inlines) do
      if inline.t == "Link" then link = inline; break end
    end
    if index == 1 then location = inlines
    elseif link.target:match("^mailto:") then email = inlines
    elseif link.target:match("^tel:") then
      local country = link.target:match("^tel:%+65") and "SG"
        or link.target:match("^tel:%+84") and "VN"
      table.insert(phones, {content = inlines, country = country})
    else
      if FORMAT == "typst" then
        link.content = {pandoc.Str(link.target:gsub("^https?://", ""):gsub("^www%.", ""):gsub("/$", ""))}
      end
      profile = inlines
    end
  end
  if not (location and email and profile and #phones > 0) then
    error("Contact paragraph must contain a location, email, profile, and phone number.")
  end
  table.sort(phones, function(a, b)
    return (a.country or "") < (b.country or "")
  end)
  local rows = {{location, email, profile}, {}}
  local countries = {
    SG = {flag = "🇸🇬", name = "Singapore"},
    VN = {flag = "🇻🇳", name = "Vietnam"},
  }
  for _, phone in ipairs(phones) do
    local content = pandoc.List()
    if phone.country then
      local country = countries[phone.country]
      content:insert(pandoc.Span({pandoc.Str(country.flag)},
        pandoc.Attr("", {"contact-country"}, {role = "img", ["aria-label"] = country.name})))
      content:insert(pandoc.Space())
    end
    content:extend(phone.content)
    table.insert(rows[2], content)
  end

  if FORMAT:match("html") then
    local blocks = {}
    for _, row in ipairs(rows) do
      local spans = pandoc.List()
      for _, content in ipairs(row) do
        if #spans > 0 then spans:insert(pandoc.Space()) end
        spans:insert(pandoc.Span(content, pandoc.Attr("", {"contact-item"})))
      end
      table.insert(blocks, pandoc.Div({pandoc.Plain(spans)}, pandoc.Attr("", {"contact-row"})))
    end
    doc.blocks[3] = pandoc.Div(blocks, pandoc.Attr("", {"contact-details"}))
  elseif FORMAT == "typst" then
    local rendered = {}
    for _, row in ipairs(rows) do
      local inlines = pandoc.List()
      for i, content in ipairs(row) do
        if i > 1 then inlines:insert(pandoc.RawInline("typst", "#h(1em)")) end
        inlines:extend(content)
      end
      table.insert(rendered, pandoc.write(pandoc.Pandoc({pandoc.Plain(inlines)}), "typst"))
    end
    doc.blocks[3] = pandoc.RawBlock("typst",
      '#block[\n#set text(size: 9pt, fill: rgb("#444444"))\n#set par(justify: false, leading: 0.6em)\n'
      .. rendered[1] .. '#linebreak()\n' .. rendered[2] .. '\n]')
  end
  return doc
end
