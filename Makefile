.PHONY: install

install:
	bundle install \
	&& cd frontend \
	&& npm install \
    && cd -