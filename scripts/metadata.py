"""Generate and verify resume metadata using Python's standard library."""

import argparse
import html
from html.parser import HTMLParser
import json
from pathlib import Path
import re
import subprocess
import xml.etree.ElementTree as ET


ROOT = Path(__file__).resolve().parent.parent
META = json.loads((ROOT / "metadata.json").read_text())
SOCIAL = {
    "og:title": META["title"],
    "og:description": META["description"],
    "og:url": META["url"],
    "og:type": "website",
    "twitter:card": "summary",
    "twitter:title": META["title"],
    "twitter:description": META["description"],
}


def head():
    for name in ("description", "author"):
        print(f'<meta name="{name}" content="{html.escape(META[name], quote=True)}">')
    print(f'<link rel="canonical" href="{html.escape(META["url"], quote=True)}">')
    for name, value in SOCIAL.items():
        attribute = "property" if name.startswith("og:") else "name"
        print(f'<meta {attribute}="{name}" content="{html.escape(value, quote=True)}">')


def pdf():
    # A before-body include sets document metadata after Pandoc's conf() rule,
    # without passing title/author variables that would add a visible title block.
    values = ", ".join(f"{key}: {json.dumps(META[key], ensure_ascii=False)}"
                       for key in ("title", "author", "description"))
    print(f"#set document({values})")


def sitemap():
    ET.register_namespace("", "http://www.sitemaps.org/schemas/sitemap/0.9")
    ns = "{http://www.sitemaps.org/schemas/sitemap/0.9}"
    root = ET.Element(ns + "urlset")
    ET.SubElement(ET.SubElement(root, ns + "url"), ns + "loc").text = META["url"]
    print(ET.tostring(root, encoding="unicode", xml_declaration=True))


class Page(HTMLParser):
    def __init__(self):
        super().__init__()
        self.fields = {}
        self.title = ""
        self.in_title = False
        self.language = None

    def handle_starttag(self, tag, attrs):
        attrs = dict(attrs)
        if tag == "html":
            self.language = attrs.get("lang")
        elif tag == "title":
            self.in_title = True
        elif tag == "meta":
            key = attrs.get("name") or attrs.get("property")
            self.fields.setdefault(key, []).append(attrs.get("content"))
        elif tag == "link" and attrs.get("rel") == "canonical":
            self.fields.setdefault("canonical", []).append(attrs.get("href"))

    def handle_endtag(self, tag):
        if tag == "title":
            self.in_title = False

    def handle_data(self, data):
        if self.in_title:
            self.title += data


def run(*args, errors="strict"):
    return subprocess.check_output(args, text=True, errors=errors)


def require(condition, message):
    if not condition:
        raise ValueError(message)


def normalized(text):
    return " ".join(text.split())


def verify(out, source):
    page = Page()
    page.feed((out / "index.html").read_text())
    require(page.title == META["title"], "HTML title mismatch")
    require(page.language == "en", "HTML language must be English")
    expected = {"description": META["description"], "author": META["author"],
                "canonical": META["url"], **SOCIAL}
    for key, value in expected.items():
        require(page.fields.get(key) == [value], f"Missing, duplicate, or incorrect HTML {key}")
    ns = {"s": "http://www.sitemaps.org/schemas/sitemap/0.9"}
    urls = ET.parse(out / "sitemap.xml").getroot()
    require(urls.tag == "{" + ns["s"] + "}urlset", "Invalid sitemap root")
    require([node.text for node in urls.findall("s:url/s:loc", ns)] == [META["url"]],
            "Sitemap must contain only the web resume URL")

    path = str(out / "resume.pdf")
    info = dict(line.split(":", 1) for line in run("pdfinfo", path).splitlines() if ":" in line)
    for key in ("Title", "Author"):
        require(info.get(key, "").strip() == META[key.lower()], f"PDF {key} mismatch")
    require(info.get("Tagged", "").strip() == "yes", "PDF must retain accessibility tags")
    require(info.get("Encrypted", "").strip() == "no", "PDF must allow text extraction")
    xmp = ET.fromstring(run("pdfinfo", "-meta", path))
    dc = "{http://purl.org/dc/elements/1.1/}"
    for field, key in (("title", "title"), ("creator", "author"), ("description", "description")):
        node = xmp.find(".//" + dc + field)
        require(node is not None and normalized("".join(node.itertext())) == META[key],
                f"PDF XMP {field} mismatch")
    fonts = run("pdffonts", path).splitlines()[2:]
    require(bool(fonts) and all(line.split()[-5] == "yes" for line in fonts),
            "PDF fonts must be embedded")
    # Poppler can emit raw UTF-16 heading labels here; inspect the ASCII tag names.
    structure = run("pdfinfo", "-struct", path, errors="replace")
    require(all(re.search(r"^\s*" + tag + r"\b", structure, re.M) for tag in ("Document", "H1", "H2", "H3", "Link")),
            "PDF must expose document, heading, and link structure")

    text = normalized(run("pdftotext", path, "-"))
    markdown = source.read_text()
    headings = re.findall(r"^#{1,3} (.+)$", markdown, re.M)
    position = 0
    for heading in headings:
        found = text.find(normalized(heading), position)
        require(found >= 0, f"PDF heading missing or out of order: {heading}")
        position = found + len(normalized(heading))
    contacts = next(line for line in markdown.splitlines() if "mailto:" in line)
    # Inspect visible labels, not compact phone numbers inside tel: destinations.
    visible_contacts = re.sub(r"\[([^\]]+)\]\([^)]+\)", r"\1", contacts)
    for phone in re.findall(r"\+\d[\d ]+\d", visible_contacts):
        require(normalized(phone) in text, f"PDF phone missing: {phone}")
    links = re.findall(r"\]\(([^)]+)\)", markdown)
    urls = run("pdfinfo", "-url", path)
    for link in links:
        require(link in urls, f"PDF link missing: {link}")
        if link.startswith("mailto:"):
            require(link[7:] in text, "PDF email missing from extracted text")
    print("Verified HTML metadata, sitemap, PDF Info/XMP, tags, fonts, heading order, contacts, and links.")
    print("Actual ATS import and full accessibility conformance are not validated.")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("command", choices=("title", "html", "pdf", "sitemap", "verify"))
    parser.add_argument("--out", type=Path, default=Path("site"))
    parser.add_argument("--source", type=Path, default=Path("resume.md"))
    args = parser.parse_args()
    if args.command == "title":
        print(META["title"])
    elif args.command == "html":
        head()
    elif args.command == "pdf":
        pdf()
    elif args.command == "sitemap":
        sitemap()
    else:
        verify(args.out, args.source)
