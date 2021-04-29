build:
	asciidoctor \
	-r asciidoctor-diagram \
	index.adoc

container:
	docker run --rm -itv /$(PWD)://wrk -w //wrk/doc asciidoctor/docker-asciidoctor make
