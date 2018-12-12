# ---------------------------------------------------------------------------
# --                                                                       --
# --                   (C) 2016-2018 Revanth Kamaraj.                      --
# --                                                                       -- 
# -- ------------------------------------------------------------------------
# --                                                                       --
# -- This program is free software; you can redistribute it and/or         --
# -- modify it under the terms of the GNU General Public License           --
# -- as published by the Free Software Foundation; either version 2        --
# -- of the License, or (at your option) any later version.                --
# --                                                                       --
# -- This program is distributed in the hope that it will be useful,       --
# -- but WITHOUT ANY WARRANTY; without even the implied warranty of        --
# -- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         --
# -- GNU General Public License for more details.                          --
# --                                                                       --
# -- You should have received a copy of the GNU General Public License     --
# -- along with this program; if not, write to the Free Software           --
# -- Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA         --
# -- 02110-1301, USA.                                                      --
# --                                                                       --
# ---------------------------------------------------------------------------

.DEFAULT_GOAL=view

view: ../../doc/ZAP_PROCESSOR_CORE_DATASHEET.pdf
	evince ../../doc/ZAP_PROCESSOR_CORE_DATASHEET.pdf

../../doc/ZAP_PROCESSOR_CORE_DATASHEET.pdf: zap_ug.tex
	mkdir -p ../../doc/ ../../obj/doc/
	pdflatex -output-directory ../../obj/doc/ zap_ug.tex
	mv ../../obj/doc/zap_ug.pdf ../../doc/ZAP_PROCESSOR_CORE_DATASHEET.pdf

clean:
	rm -rfv ../../obj/doc/*zap_ug* ../../doc/ZAP_PROCESSOR_CORE_DATASHEET.pdf
	rm -rfv zap_ug.pdf zap_ug.log zap_ug.aux ZAP_PROCESSOR_CORE_DATASHEET.pdf

.PHONY: view
.PHONY: clean
