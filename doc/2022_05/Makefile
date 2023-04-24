build-main:
	pdflatex -synctex=1 -interaction=nonstopmode 2022_05_main.tex
	mv 2022_05_main.pdf ../pdf/2022_05_main.pdf

build-sim:
	pdflatex -synctex=1 -interaction=nonstopmode 2022_05_sim.tex
	mv 2022_05_sim.pdf ../pdf/

build-cosim:
	pdflatex -synctex=1 -interaction=nonstopmode 2022_05_cosim.tex
	mv 2022_05_cosim.pdf ../pdf/

build-control:
	pdflatex -synctex=1 -interaction=nonstopmode 2022_05_control.tex
	mv 2022_05_control.pdf ../pdf/

build-other:
	pdflatex -synctex=1 -interaction=nonstopmode 2022_05_other.tex
	mv 2022_05_other.pdf ../pdf/

container:
	docker run --rm \
	  -v /$(PWD)://wrk -w //wrk/doc/2022_05 \
	  --security-opt label=disable \
	  btdi/latex make \
	    build-main \
	    build-sim \
	    build-cosim \
	    build-other \
	    build-control \
	    clean

clean:
	rm -f *.aux *.log *.nav *.out *.snm *.synctex* *.toc *.vrb
