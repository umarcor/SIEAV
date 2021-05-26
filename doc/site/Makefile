# Authors:
#   Unai Martinez-Corral
#
# Copyright 2021 Unai Martinez-Corral <unai.martinezcorral@ehu.eus>
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

pdf:
	[ -f revnumber.txt ] && REVNUMBER='-a revnumber='"$$(cat revnumber.txt)" || unset REVNUMBER; \
	asciidoctor-pdf $$REVNUMBER \
	  -a pdf-theme=pdf-theme.yml \
	  -r asciidoctor-diagram \
	  main.adoc \
	  --out-file ../pdf/SIEAV-CVS-FLOSS.pdf

html:
	[ -f revnumber.txt ] && REVNUMBER='-a revnumber='"$$(cat revnumber.txt)" || unset REVNUMBER; \
	asciidoctor $$REVNUMBER \
	  -r asciidoctor-diagram \
	  index.adoc

revnumber:
	git describe | sed 's#\([^-]*-g\)#r\1#;' > revnumber.txt

container: revnumber
	docker run --rm -v /$(PWD)://wrk/ -w //wrk/doc/site btdi/asciidoctor make pdf html
