# -*- coding: utf-8 -*-

# Authors:
#   Unai Martinez-Corral
#
# Copyright 2021-2026 Unai Martinez-Corral <unai.martinezcorral@ehu.eus>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# SPDX-License-Identifier: Apache-2.0

from pathlib import Path
from json import loads as json_loads

ROOT = Path(__file__).resolve().parent

# -- General configuration ---------------------------------------------------------------------------------------------

extensions = [
    "sphinx.ext.extlinks",
    "sphinx.ext.intersphinx",
    "sphinxcontrib.bibtex",
    'myst_parser'
]

bibtex_default_style = 'alpha'
bibfiles = [
    ROOT / 'references/CoSim.bib',
    ROOT / 'references/FLOSS.bib',
    ROOT / 'references/Standards.bib',
    ROOT / 'references/Verification.bib',
]
bibtex_bibfiles = [str(item) for item in bibfiles]
for item in bibfiles:
    if not item.exists():
        raise Exception(f"Bibliography file {item} does not exist!")

source_suffix = {
    '.rst': 'restructuredtext',
    '.md': 'markdown'
}

master_doc = "index"
project = "SIEAV CVS"
copyright = "2020-2026, Unai Martinez-Corral"
author = "Unai Martinez-Corral"

version = "latest"
release = version  # The full version, including alpha/beta/rc tags.

language = 'en'

exclude_patterns = ['references/VHDL.md']

numfig = True

# reST settings
prologPath = "prolog.inc"
try:
    with open(prologPath, "r") as prologFile:
        rst_prolog = prologFile.read()
except Exception as ex:
    print("[ERROR:] While reading '{0!s}'.".format(prologPath))
    print(ex)
    rst_prolog = ""

# -- Options for HTML output -------------------------------------------------------------------------------------------

html_context = {}
ctx = ROOT / "context.json"
if ctx.is_file():
    html_context.update(json_loads(ctx.open("r").read()))

html_theme = "furo"

html_theme_options = {
    "source_repository": "https://github.com/umarcor/SIEAV",
    "source_branch": "main",
    "source_directory": "doc/site",
    "sidebar_hide_name": True,
}

html_title = "Co-simulation and behavioural verification with VHDL, C/C++ and Python/m"

html_static_path = ["_static"]

html_logo = str(Path(html_static_path[0]) / "logo.png")
html_favicon = str(Path(html_static_path[0]) / "favicon.png")

htmlhelp_basename = "SIEAVCVSDoc"

# -- Options for LaTeX output ------------------------------------------------------------------------------------------

latex_elements = {
    "papersize": "a4paper",
}

latex_documents = [
    (
        master_doc,
        "SIEAV-CVS-Doc.tex",
        "Co-simulation and behavioural verification with VHDL, C/C++ and Python/m",
        author,
        "manual",
    ),
]

# #70358c
#
# header:
#   left: '*https://github.com/umarcor/SIEAV[UPV/EHU SIEAV CVS FLOSS]*'
#   center: '{author}'
#   right: '*https://umarcor.github.io/SIEAV[umarcor.github.io/SIEAV]*'
#
# footer:
#   right: '{page-number} / {page-count}'
#   center: '{revnumber}'
#   left: '{docdate}'

# -- Sphinx.Ext.InterSphinx --------------------------------------------------------------------------------------------

intersphinx_mapping = {
    "python":      ("https://docs.python.org/3/", None),
    "constraints": ("https://hdl.github.io/constraints", None),
    "edaa":        ("https://edaa-org.github.io", None),
    "qus":         ("https://dbhi.github.io/qus", None),
    "vasg":        ("https://ieee-p1076.gitlab.io", None),
    "osvb":        ("https://umarcor.github.io/osvb", None),
    "vunit":       ("http://vunit.github.io", None)
}

# -- Sphinx.Ext.ExtLinks -----------------------------------------------------------------------------------------------

extlinks = {
    "wikipedia": ("https://en.wikipedia.org/wiki/%s", "wikipedia:%s"),
    "awesome":   ("https://hdl.github.io/awesome/items/%s", "%s"),
    "gh":        ("https://github.com/%s", "gh:%s"),
    "ghsharp":   ("https://github.com/umarcor/SIEAV/issues/%s", "#%s"),
    "ghissue":   ("https://github.com/umarcor/SIEAV/issues/%s", "issue #%s"),
    "ghpull":    ("https://github.com/umarcor/SIEAV/pull/%s", "pull request #%s"),
    "ghsrc":     ("https://github.com/umarcor/SIEAV/blob/main/%s", "%s"),
}
