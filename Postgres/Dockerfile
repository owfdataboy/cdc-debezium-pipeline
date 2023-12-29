FROM postgres:13.4

RUN apt-get update
RUN apt-get install -y postgresql-13-wal2json

ENTRYPOINT ["docker-entrypoint.sh"]
EXPOSE 5432

CMD ["postgres"]
