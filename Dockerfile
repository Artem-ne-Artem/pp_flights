FROM python:3.10-slim

# Устанавливаем git и зависимые пакеты для dbt
RUN apt-get update && \
    apt-get install -y git build-essential && \
    rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir dbt-postgres==1.10.0

WORKDIR /usr/app/dbt
ENTRYPOINT ["dbt"]