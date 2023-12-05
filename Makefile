.PHONY: install

install:
	bundle install \
	&& cd frontend \
	&& npm install \
    && cd -

start:
	foreman start --procfile=Procfile.dev
