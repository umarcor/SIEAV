build:
	asciidoctor \
	-r asciidoctor-diagram \
	index.adoc

container:
	docker run --rm -v /$(PWD)://wrk -w //wrk/doc asciidoctor/docker-asciidoctor make
