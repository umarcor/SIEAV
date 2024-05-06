build-main:
	pdflatex -synctex=1 -interaction=nonstopmode 2024_04_main.tex
	mv 2024_04_main.pdf ../pdf/2024_04_main.pdf

build-sim:
	pdflatex -synctex=1 -interaction=nonstopmode 2024_04_sim.tex
	mv 2024_04_sim.pdf ../pdf/

build-cosim:
	pdflatex -synctex=1 -interaction=nonstopmode 2024_04_cosim.tex
	mv 2024_04_cosim.pdf ../pdf/

build-control:
	pdflatex -synctex=1 -interaction=nonstopmode 2024_04_control.tex
	mv 2024_04_control.pdf ../pdf/

build-other:
	pdflatex -synctex=1 -interaction=nonstopmode 2024_04_other.tex
	mv 2024_04_other.pdf ../pdf/

container:
	docker run --rm \
	  -v /$(PWD)://wrk -w //wrk/doc/2024_04 \
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
