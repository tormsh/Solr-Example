FROM solr:8.2.0
RUN mkdir /var/solr/data/Collection
COPY --chown=solr:solr Collection /var/solr/data/Collection
