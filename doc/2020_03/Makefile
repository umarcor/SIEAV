build:
	pdflatex -synctex=1 -interaction=nonstopmode main.tex
	mv main.pdf ../pdf/2020_03.pdf

container:
	docker run --rm -v /$(PWD)://wrk -w //wrk/doc/2020_03 btdi/latex make build clean

clean:
	rm -f *.aux *.log *.nav *.out *.snm *.synctex.gz *.toc
