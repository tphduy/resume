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

  doc.meta["resume-name"] = pandoc.MetaBlocks({blocks[1]})
  doc.meta["resume-role"] = pandoc.MetaBlocks({blocks[2]})
  doc.meta["resume-contact"] = pandoc.MetaBlocks({blocks[3]})
  for _ = 1, 3 do
    blocks:remove(1)
  end
  return doc
end
