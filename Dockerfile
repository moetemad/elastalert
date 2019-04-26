FROM python:2.7-alpine AS builder
ARG ELASTALERT_VERSION=0.1.39
ARG ELASTALERT_HOME=/opt/elastalert

RUN apk add --update ca-certificates openssl-dev openssl libffi-dev gcc musl-dev wget && \
    wget https://github.com/matsgoran/elastalert/archive/doc_type_and_support_for_es66_es7.zip -O elastalert.zip && \
    unzip elastalert.zip && \
    mv elastalert-* "${ELASTALERT_HOME}"

WORKDIR "${ELASTALERT_HOME}"

# Needed until https://github.com/Yelp/elastalert/pull/2194 is merged
RUN sed -i 's/elasticsearch/elasticsearch>=7.0.0,<8.0.0/' requirements.txt && \
    sed -i "s/'elasticsearch',/'elasticsearch>=7.0.0,<8.0.0',/" setup.py && \
    python setup.py install && \
    pip install -r requirements.txt

FROM python:2.7-alpine AS runner
RUN apk add --update --no-cache curl tzdata make libmagic
COPY --from=builder /usr/local/lib/python2.7/site-packages/ /usr/local/lib/python2.7/site-packages/
COPY --from=builder /opt/elastalert /opt/elastalert
COPY --from=builder /usr/local/bin/elastalert* /usr/local/bin/

WORKDIR /opt/elastalert
COPY . /opt/elastalert
EXPOSE 3030
ENTRYPOINT ["/usr/local/bin/elastalert"]
