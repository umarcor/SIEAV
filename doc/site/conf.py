# -*- coding: utf-8 -*-

# Authors:
#   Unai Martinez-Corral
#
# Copyright 2021-2022 Unai Martinez-Corral <unai.martinezcorral@ehu.eus>
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

#from sys import path as sys_path
from os.path import abspath
from pathlib import Path
from json import loads as json_loads

ROOT = Path(__file__).resolve().parent

#sys_path.insert(0, abspath("."))

# -- General configuration ---------------------------------------------------------------------------------------------

extensions = [
    "sphinx.ext.autodoc",
    "sphinx.ext.extlinks",
    "sphinx.ext.intersphinx",
    "sphinxcontrib.bibtex",
]

bibtex_default_style = 'plain'
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

templates_path = ["_templates"]

source_suffix = {
    ".rst": "restructuredtext",
}

master_doc = "index"
project = "SIEAV CVS"
copyright = "2020-2022, Unai Martinez-Corral"
author = "Unai Martinez-Corral"

version = "latest"
release = version  # The full version, including alpha/beta/rc tags.

language = None

exclude_patterns = [
    "_build",
    "_theme",
]

numfig = True

# -- Options for HTML output -------------------------------------------------------------------------------------------

html_context = {}
ctx = ROOT / "context.json"
if ctx.is_file():
    html_context.update(json_loads(ctx.open("r").read()))

if (ROOT / "_theme").is_dir():
    html_theme_path = ["."]
    html_theme = "_theme"
    html_theme_options = {
        "logo_only": True,
        "home_breadcrumbs": True,
        "vcs_pageview_mode": "blob",
    }
    html_css_files = [
        "theme_overrides.css",
    ]
else:
    html_theme = "alabaster"

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

# -- Options for manual page output ------------------------------------------------------------------------------------

# One entry per manual page. List of tuples
# (source start file, name, description, authors, manual section).
man_pages = [
    (
        master_doc,
        "SIEAV-CVS",
        "Co-simulation and behavioural verification with VHDL, C/C++ and Python/m",
        [author],
        1,
    )
]

# -- Options for Texinfo output ----------------------------------------------------------------------------------------

texinfo_documents = [
    (
        master_doc,
        "SIEAV-CVS",
        "Co-simulation and behavioural verification with VHDL, C/C++ and Python/m",
        author,
        "HDL simulation",
        "HDL verification.",
        "Miscellaneous",
    ),
]

# -- Sphinx.Ext.InterSphinx --------------------------------------------------------------------------------------------

intersphinx_mapping = {
    "python":      ("https://docs.python.org/3/", None),
    "constraints": ("https://hdl.github.io/constraints", None),
    "edaa":        ("https://edaa-org.github.io", None),
    "qus":         ("https://dbhi.github.io/qus", None),
}

# -- Sphinx.Ext.ExtLinks -----------------------------------------------------------------------------------------------

extlinks = {
    "wikipedia": ("https://en.wikipedia.org/wiki/%s", None),
    "awesome":   ("https://hdl.github.io/awesome/items/%s", ""),
    "gh":        ("https://github.com/%s", "gh:"),
    "ghsharp":   ("https://github.com/umarcor/SIEAV/issues/%s", "#"),
    "ghissue":   ("https://github.com/umarcor/SIEAV/issues/%s", "issue #"),
    "ghpull":    ("https://github.com/umarcor/SIEAV/pull/%s", "pull request #"),
    "ghsrc":     ("https://github.com/umarcor/SIEAV/blob/main/%s", ""),
}
