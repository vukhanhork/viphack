FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

COPY requirements.txt /app/requirements.txt
RUN apt-get update && apt-get install -y --no-install-recommends build-essential \
    && pip install --upgrade pip \
    && pip install -r /app/requirements.txt \
    && apt-get remove -y build-essential \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

COPY . /app

VOLUME ["/app/data"]
ENV DB_NAME=/app/data/store.db

EXPOSE 5000

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app", "--workers", "2", "--threads", "2"]
