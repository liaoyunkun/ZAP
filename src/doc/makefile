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
