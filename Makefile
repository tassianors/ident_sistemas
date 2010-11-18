FILE=relat
FILETEX=$(FILE).tex
FILEDVI=$(FILE).dvi
FILEBIB=$(FILE).aux
OUTPUT=Output/system_identification-final.pdf

.PHONY: clean bib pdf

all:
	latex $(FILETEX)

bib: 
	bibtex $(FILEBIB)
	latex $(FILE)
pdf:
	dvipdf -s $(FILEDVI) $(OUTPUT)

clean:
	rm *.aux *.log *.dvi *.bbl *.blg 
