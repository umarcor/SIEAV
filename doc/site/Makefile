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

SPHINXOPTS    =
SPHINXBUILD   = sphinx-build
PAPER         =
BUILDDIR      = _build

PAPEROPT_a4     = -D latex_paper_size=a4
PAPEROPT_letter = -D latex_paper_size=letter
ALLSPHINXOPTS   = -d $(BUILDDIR)/doctrees -T -D language=en $(PAPEROPT_$(PAPER)) $(SPHINXOPTS) .

#---

references:
	curl -fsSL https://github.com/umarcor/umarcor/archive/refs/heads/main.tar.gz | \
	tar -xz --strip-components=1 umarcor-main/references/

#---

theme:
	mkdir _theme
	curl -fsSL https://codeload.github.com/buildthedocs/sphinx.theme/tar.gz/v1 | \
	tar -xzC _theme --strip-components=1

#---

%:
	$(SPHINXBUILD) -b $@ $(ALLSPHINXOPTS) $(BUILDDIR)/$@
