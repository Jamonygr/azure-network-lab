"""Run with python -m unittest discover -s tests/tooling -p 'test_*.py'."""
import importlib.util
from pathlib import Path
import unittest

spec = importlib.util.spec_from_file_location("checks", Path(__file__).resolve().parents[2] / "scripts/check_repository.py")
checks = importlib.util.module_from_spec(spec)
spec.loader.exec_module(checks)


class MarkdownAnchors(unittest.TestCase):
    def test_duplicate_and_formatted_headings(self):
        self.assertEqual(checks.headings("# One\n# One\n## `Two` & three!\n"), {"one", "one-1", "two--three"})

    def test_examples_are_not_headings(self):
        self.assertEqual(checks.headings("# Real\n```powershell\n# Comment\n```\n"), {"real"})

    def test_generated_html_anchors(self):
        self.assertIn("input_name", checks.headings('<a name="input_name"></a>'))


if __name__ == "__main__":
    unittest.main()
