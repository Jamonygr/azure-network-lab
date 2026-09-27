"""Credential-free checks; Python standard library only. Never reads local state."""
from __future__ import annotations
import re
import sys
from pathlib import Path
from urllib.parse import unquote, urlsplit
import xml.etree.ElementTree as ET


def markdown_body(text: str) -> str:
    return re.sub(r"(?m)^\s*(```|~~~)[\s\S]*?^\s*\1[^\n]*$", "", text)


def headings(text: str) -> set[str]:
    result, counts = set(), {}
    for match in re.finditer(r"(?m)^#{1,6}\s+(.+?)\s*#*\s*$", markdown_body(text)):
        title = re.sub(r"<[^>]+>", "", match[1]).lower()
        title = re.sub(r"[^\w\- ]", "", title).replace(" ", "-")
        number = counts.get(title, 0)
        result.add(title + (f"-{number}" if number else ""))
        counts[title] = number + 1
    result.update(re.findall(r'<a\s+(?:id|name)=["\']([^"\']+)', text))
    return result


def check(root: Path) -> list[str]:
    errors: list[str] = []
    files = [p for p in root.rglob("*") if p.is_file() and not any(x in p.parts for x in (".git", ".terraform", ".local", "node_modules"))]
    docs = [p for p in files if p.suffix.lower() == ".md"]
    links = 0
    for doc in docs:
        text = markdown_body(doc.read_text(encoding="utf-8-sig"))
        targets = re.findall(r"\[[^\]\n]+\]\((<[^>]+>|[^\s)]+)(?:\s+[\"'][^\n]*?[\"'])?\)", text)
        targets += re.findall(r"(?m)^\s*\[[^]]+\]:\s*(\S+)", text)
        for raw in targets:
            target = unquote(raw.strip("<>").replace("\\_", "_"))
            parts = urlsplit(target)
            if parts.scheme or target.startswith("//"):
                if parts.scheme in ("https", "http") and not parts.netloc:
                    errors.append(f"{doc.relative_to(root)}: invalid URL {target}")
                continue
            path_part = parts.path
            destination = (doc.parent / path_part).resolve() if path_part else doc.resolve()
            links += 1
            if not destination.is_relative_to(root.resolve()) or not destination.exists():
                errors.append(f"{doc.relative_to(root)}: missing local link {target}")
            elif parts.fragment and destination.suffix.lower() == ".md":
                if parts.fragment not in headings(destination.read_text(encoding="utf-8-sig")):
                    errors.append(f"{doc.relative_to(root)}: missing heading {target}")
    tests = [p for p in files if p.name.endswith(".tftest.hcl")]
    for test in tests:
        content = test.read_text(encoding="utf-8-sig")
        runs = len(re.findall(r'^run\s+"', content, re.M))
        plans = len(re.findall(r'^\s*command\s*=\s*plan\s*$', content, re.M))
        if runs == 0 or runs != plans or not re.search(r'mock_provider\s+"azurerm"', content):
            errors.append(f"{test.relative_to(root)}: every run must explicitly use plan with mocked AzureRM")
    diagrams = [p for p in files if p.suffix == ".mmd"]
    for source in diagrams:
        rendered = source.with_suffix(".svg")
        if not rendered.exists():
            errors.append(f"{source.relative_to(root)}: missing SVG render")
            continue
        try:
            element = ET.parse(rendered).getroot()
            if not element.attrib.get("viewBox"):
                errors.append(f"{rendered.relative_to(root)}: missing viewBox")
            tags = {node.tag.split("}")[-1] for node in element.iter()}
            if not {"title", "desc"}.issubset(tags):
                errors.append(f"{rendered.relative_to(root)}: missing accessible title/description")
        except ET.ParseError as error:
            errors.append(f"{rendered.relative_to(root)}: invalid SVG: {error}")
    for file in files:
        relative = file.relative_to(root).as_posix()
        if (relative.startswith((".github/workflows/", "pipelines/")) and file.suffix in (".yml", ".yaml")) or file.name.startswith("azure-pipelines"):
            errors.append(f"{relative}: pipeline definitions are outside this repository's scope")
    if len(tests) < 8:
        errors.append("Expected mocked tests for the root and seven independent examples")
    if len(diagrams) < 8:
        errors.append("Expected at least eight editable architecture/learning diagrams")
    print(f"Checked {len(docs)} Markdown files, {links} local links, {len(tests)} mock test files, {len(diagrams)} diagram pairs.")
    return errors


if __name__ == "__main__":
    failures = check(Path(sys.argv[1]).resolve() if len(sys.argv) > 1 else Path(__file__).resolve().parents[1])
    for failure in failures:
        print(f"FAIL: {failure}")
    raise SystemExit(bool(failures))
